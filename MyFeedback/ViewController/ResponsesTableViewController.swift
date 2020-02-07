//
//  ResponsesTableViewController.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 04/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift


class ResponsesTableViewController: UITableViewController, ReachabilityObserverDelegate {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var responses = [CustomQuery]()
    var vSpinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.initData()
            self.tableView.reloadData()
        }
    }
    
    private func initData(){
        var users = [User]()
        do {
            users = try context.fetch(User.fetchRequest())
            if(users.isEmpty){
                dismiss(animated: true, completion: nil)
                //add profile details
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vcEditProfile") as? EditProfileViewController
                
                vc?.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                //get survey data
                do{
                    responses = try context.fetch(CustomQuery.fetchRequest())
                }catch let error as NSError {
                    print("Could not fetch queries. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch users. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return responses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellResponse", for: indexPath) as! ResponseTableViewCell
        
        // Configure the cell...
        let response = responses[indexPath.row]
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        let date = formatter.string(from: response.date!)
        
        cell.lblDate.text = date
        cell.lblSurvey.text = response.title
        
        //add radius to the button
        cell.btnSend.layer.cornerRadius = 12
        cell.btnSend.setTitleColor(.white, for: .normal)
        
        cell.btnSend.setTitle("Sent", for: .disabled)
        cell.btnSend.setTitle("Send", for: .normal)
            
        if(response.sent){
            cell.btnSend.isEnabled=false
            cell.btnSend.backgroundColor = UIColor.green
        }else{
            cell.btnSend.isEnabled=true
            cell.btnSend.backgroundColor = UIColor.red
        }
        
        // assign the youtuber model to the cell
        cell.customQuery = response
        
        // the 'self' here means the view controller, set view controller as the delegate
        cell.delegate = self
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch deleteResponse(position: indexPath.row) {
            case 1:
                // Remove item from existing list
                responses.remove(at: indexPath.row)
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                showToast(message: "Response Deleted", seconds: ToastTime)
            default:
                showToast(message: "Response could't be deleted", seconds: ToastTime)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        try? addReachabilityObserver()
    }
    
    deinit {
        removeReachabilityObserver()
    }
    
    
    //MARK: Reachability
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            showToast(message: "No internet connection.\n Sync Paused", seconds: ToastTime)
        }else{
            showToast(message: "Syncing Data...", seconds: ToastTime)
            
            //upload un-uploaded queries
            let unsentQueries = getUnsentQueries()
            if(!unsentQueries.isEmpty){
                //start showing loading indicator
                //show spinner here to only launch one instance since queries are multiple
                self.showSpinner(onView: self.view)
                uploadData(queries: unsentQueries, isMultiple: true)
            }
        }
    }
    
    var pos = 0
    func uploadData(queries: [CustomQuery], isMultiple: Bool){
        
        // MARK: Alamofire manager
        let manager = SessionManager.default
        
        _ = manager.rx
            .request(.get, URL
                //,parameters: ["email": john@doe.com, "password": "onlyjohnknowsme"]
        )
            .responseData()
            .expectingObject(ofType: Welcome.self) // <-- specify what object is expected
            .subscribe(onNext: { apiResult in
                switch apiResult{
                case let .success(succesResponse):
                    // handling the successful response
                    //write to database that response has been sent
                    
                    //if is single
                    if(!isMultiple){
                        switch(markSent(customQuery: queries[0])){
                        case 1:
                            self.tableView.reloadData()
                            self.showToast(message: "Response uploaded successfully", seconds: ToastTime)
                            break
                        default:
                            self.showToast(message: "Sorry.There seems to be a problem writing to the database", seconds: ToastTime)
                            break
                        }
                        self.removeSpinner()
                    }else{
                        //if multiple
                        if(self.pos < queries.count){
                            switch(markSent(customQuery: queries[self.pos])){
                            case 1:
                                self.tableView.reloadData()
                                self.showToast(message: "Responses uploaded successfully", seconds: ToastTime)
                                break
                            default:
                                self.showToast(message: "Sorry.There seems to be a problem writing to the database", seconds: ToastTime)
                                break
                            }
                            self.pos += 1
                            self.uploadData(queries: queries, isMultiple: true)
                        }else{
                            //data is done uploading
                            self.showToast(message: "Data Synced", seconds: ToastTime)
                        }
                    }
                case let .failure(apiErrorMessage):
                    // handling the erroneous response
                    self.showToast(message: apiErrorMessage.error_message, seconds: ToastTime)
                }
                
                //Stop showing loading indicator
                self.removeSpinner()
                
            },onError:{ err in
                //Stop showing loading indicator
                self.removeSpinner()
                print(err.localizedDescription)
                // handle client originating error
                self.showToast(message: "Check your internet connection", seconds: ToastTime)
            })
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ResponsesTableViewController {
    
    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message,
                                      preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: {alert.dismiss(animated: true)})
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
}

extension ResponsesTableViewController : ResponseTableViewCellDelegate {
    func responseTableViewCell(_ responseTableViewCell: ResponseTableViewCell, subscribeButtonTappedFor customQuery: CustomQuery) {
        
        //upload the data on click
        var queries = [CustomQuery]()
        queries.append(customQuery)
        //show spinner here to only launch one instance since queries are multiple
        self.showSpinner(onView: self.view)

        uploadData(queries: queries, isMultiple: false)
    }
}

extension Observable where Element == (HTTPURLResponse, Data){
    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                // otherwise try
                let apiErrorMessage: ApiErrorMessage
                do{
                    // to decode an expected error
                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                } catch _ {
                    // or not. (this occurs if the API failed or doesn't return a handled exception)
                    apiErrorMessage = ApiErrorMessage(error_message: "Server Error.")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}

enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

struct ApiErrorMessage: Codable{
    var error_message: String
}
