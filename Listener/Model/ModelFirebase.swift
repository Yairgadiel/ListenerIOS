//
//  ModelFirebase.swift
//  ModelFirebase
//
//  Created by Ellie Gadiel on 13/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestore

class ModelFirebase {
	init() {
		FirebaseApp.configure()
	}
	
	// MARK: Constants
	
	private static let RECORDS_LIST_COLLECTION = "records_lists"
	
	private static let USERS_COLLECTION = "users"
	
	private static let IMAGES_STORAGE = "images"

	
	// MARK: Firestore
	
	// MARK: Records Lists
	
	/**
	 * This method adds/updates a records list
	 * @param recordsList the records list to set
	 * @param listener listener notifying of success/failure
	 */
	func add(recordsList: RecordsList, callback:@escaping (Bool)->Void) {
		let db = Firestore.firestore()
		db.collection(ModelFirebase.RECORDS_LIST_COLLECTION).document(recordsList.id!)
			.setData(recordsList.toJson()){ err in
				if let err = err {
					callback(false)
					print("Error adding document: \(err)")
				} else {
					callback(true)
				}
			}
	}
	
	func getAllRecordsList(since: Int64, callback:@escaping ([RecordsList])->Void) {
		let db  = Firestore.firestore()
		db.collection(ModelFirebase.RECORDS_LIST_COLLECTION)
			.whereField("LastUpdated", isGreaterThanOrEqualTo: Timestamp(seconds: since, nanoseconds: 0))
			.order(by: "LastUpdated", descending: true)
			.getDocuments() { (querySnapshot, err) in
				var data = [RecordsList]()
				if let err = err {
					callback(data)
					print("Error getting documents: \(err)")
				} else {
					for document in querySnapshot!.documents {
						print("\(document.documentID) => \(document.data())")
						data.append(RecordsList.fromJson(json: document.data()))
					}
					
					callback(data)
				}
			}
	}
	
	func getAllRecords(byField: String, value: String, callback:@escaping ([RecordsList])->Void) {
		let db  = Firestore.firestore()
		db.collection(ModelFirebase.RECORDS_LIST_COLLECTION)
			.whereField(byField, isEqualTo: value)
			.getDocuments() { (querySnapshot, err) in
				var data = [RecordsList]()
				if let err = err {
					callback(data)
					print("Error getting documents: \(err)")
				} else {
					for document in querySnapshot!.documents {
						print("\(document.documentID) => \(document.data())")
						data.append(RecordsList.fromJson(json: document.data()))
					}
					
					callback(data)
				}
			}
	}

 /*
	  

	  // MARK: Users

	  /**
	   * This method adds/updates a user
	   * @param user the user to set
	   * @param listener listener notifying of success/failure
	   */
	  public func setUser(User user, IOnCompleteListener listener) {
  let db  = Firestore.firestore()
		  db.collection(USERS_COLLECTION).document(user.getId())
				  .set(user)
				  .addOnSuccessListener(afunc -> listener.onComplete(true))
				  .addOnFailureListener(e -> {
					  e.printStackTrace();
					  listener.onComplete(false);
				  });
	  }

	  /**
	   * This method gets all users having the given field matching the given value
	   */
	  public func getAllUsersWithField(String field, String value, IOnUsersFetchListener listener) {
  let db  = Firestore.firestore()
		  db.collection(USERS_COLLECTION)
				  .whereEqualTo(field, value)
				  .get()
				  .addOnCompleteListener(task -> {
					  List<User> data = null;

					  if (task.isSuccessful() && task.getResult() != null) {
						  data = new ArrayList<>(task.getResult().size());

						  for (QueryDocumentSnapshot doc : task.getResult()) {
							  data.add(doc.toObject(User.class));
						  }
					  }

					  listener.onFetch(data);
				  });
	  }

	  public func getAllUsers(IOnUsersFetchListener listener) {
  let db  = Firestore.firestore()
		  db.collection(USERS_COLLECTION)
				  .get()
				  .addOnCompleteListener(task -> {
					  List<User> data = null;

					  if (task.isSuccessful() && task.getResult() != null) {
						  data = new ArrayList<>(task.getResult().size());

						  for (QueryDocumentSnapshot doc : task.getResult()) {
							  data.add(doc.toObject(User.class));
						  }
					  }

					  listener.onFetch(data);
				  });
	  }

	  

	  

	  // MARK: Authentication

	  @Nullable
	  public User getLoggedUser() {
  let auth = Auth.auth()
		  FirebaseUser fbUser = auth.getCurrentUser();
		  User loggedUser = null;

		  if (fbUser != null) {
			  loggedUser = new User(fbUser.getUid(), fbUser.getDisplayName(), fbUser.getEmail());
		  }

		  return loggedUser;
	  }

	  public func signUp(String name, String email, String password, IOnCompleteListener listener) {
  let auth = Auth.auth()
  auth.createUserWithEmailAndPassword(email, password)
				  .addOnCompleteListener(task -> {
					  if (!task.isSuccessful()) {
						  listener.onComplete(false);
					  }
					  else {
						  // Sign in success, update UI with the signed-in user's information
						  FirebaseUser user = auth.getCurrentUser();

						  if (user == null) {
							  listener.onComplete(false);
						  }
						  else {
							  // Setting the new user's name
							  UserProfileChangeRequest profileUpdates = new UserProfileChangeRequest.Builder()
									  .setDisplayName(name).build();

							  user.updateProfile(profileUpdates).addOnCompleteListener(updateTask -> {
										  if (task.isSuccessful()) {
											  listener.onComplete(true);
										  }
										  else {
											  // If unable to set the user's name for some reason - delete it
											  user.delete();
											  listener.onComplete(false);
										  }
									  });
						  }
					  }
				  });
	  }

	  public func signIn(String email, String password, IOnCompleteListener listener) {
  let auth = Auth.auth()
		  auth.signInWithEmailAndPassword(email, password)
				  .addOnCompleteListener(task -> listener.onComplete(task.isSuccessful()));
	  }

	  public func signOut() {
  let auth = Auth.auth()
		  auth.signOut();
	  }

	  
  */

	  // MARK: Storage

	public func uploadImage(name: String, img: UIImage, callback: @escaping (String)->Void) {
		let storageRef = Storage.storage().reference()
		let imageRef = storageRef.child(ModelFirebase.IMAGES_STORAGE).child(name)
		let data = img.jpegData(compressionQuality: 0.8)
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"
		imageRef.putData(data!, metadata: metadata) { (metadata, error) in
			imageRef.downloadURL { (url, error) in guard let downloadURL = url else {
				callback("")
				return
			}
				print("url: \(downloadURL)")
				callback(downloadURL.absoluteString)
			}
		}
	}
	
	public func loadImage(name: String, callback: @escaping (UIImage?)->Void) {
		let storageRef = Storage.storage().reference()
		let imageRef = storageRef.child(ModelFirebase.IMAGES_STORAGE).child(name)
		imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
			if error != nil {
				callback(nil)
			}
			else {
				let image = UIImage(data: data!)
				callback(image)
			}
		}
	}
	
	public func deleteImage(name: String, callback: @escaping (Bool)->Void) {
		// Create a storage reference from our app
		let storageRef = Storage.storage().reference()
		let imageRef = storageRef.child(ModelFirebase.IMAGES_STORAGE).child(name);
		
		// Delete the file
		imageRef.delete() { error in
			if let error = error {
				print("error: \(error)")
				callback(false)
			}
			else {
				callback(true)
			}
		}
	}
}
