import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud import firestore as cloud
from flask import jsonify


db = None
def start_server():
    global db
    cred = credentials.Certificate('timezmoney-firebase-adminsdk-daz6x-0cd822cd73.json')
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    
def create_user(user:dict):
    ref = db.collection('users').add(user)

def update_user(user:dict):
    global db
    db.collection('users').document(user['uid']).set(user)

def get_user_by_uid(uid:str):
    global db
    ref = db.collection('users').where("uid","==",uid).stream()
    user = None 
    for doc in ref:
        user = doc.to_dict()
    return user

def get_majors():
    global db 
    ref = db.collection('jobsMajors').stream()
    majors = []
    for doc in ref:
        majors.append(doc.to_dict()['major'])
    return majors
    
def get_jobs_of_employer(uid:str):
    global db
    ref = db.collection('jobs').where('employerUid','==',uid).stream()
    jobs = []
    for doc in ref:
        jobs.append(doc.to_dict())
    for job in jobs:
        job['location'] = str(job['location'].latitude)+','+str(job['location'].longitude)
    return jobs 

def get_relevent_jobs():
    global db
    ref = db.collection('jobs').stream()
    jobs = []
    for doc in ref:
        jobs.append(doc.to_dict())
    for job in jobs:
        job['location'] = str(job['location'].latitude)+','+str(job['location'].longitude)
    return jobs 

def get_reviews_on_user(uid:str):
    ref = db.collection('reviews').where('receiver','==',uid)
    stream = ref.stream()
    reviews = []
    for doc in stream:
        reviews.append(doc.to_dict())
    return reviews

def get_jobs_of_major(major:str):
    global db
    ref = db.collection('jobs').where("major",'==',major).stream()
    jobs = []
    for doc in ref:
        jobs.append(doc.to_dict())
    for job in jobs:
        job['location'] = str(job['location'].latitude)+','+str(job['location'].longitude)
    return jobs 

def get_job_by_uid(uid:str):
    global db
    ref = db.collection('jobs').where('uid','==',uid).stream()
    job = None
    for doc in ref:
        job = doc.to_dict()
    job['location'] = str(job['location'].latitude)+','+str(job['location'].longitude)
    return job

def get_past_jobs_approved_to(uid:str):
    global db
    ref = db.collection('jobs').where('approvedWorkers','array_contains',uid).stream()
    jobs = []
    for doc in ref:
        jobs.append(doc.to_dict())
    for job in jobs:
        job['location'] = str(job['location'].latitude)+','+str(job['location'].longitude)
    return jobs 

def add_worker_to_wait_list(jobUid:str,workerUid:str):
    global db
    db.collection('jobs').document(jobUid).update({'signedWorkers': cloud.ArrayUnion([workerUid])})

def approve_worker(jobUid:str,workerUid:str):
    global db
    db.collection('jobs').document(jobUid).update({'signedWorkers': cloud.ArrayRemove([workerUid]),'approvedWorkers': cloud.ArrayUnion([f'{workerUid},unseen'])})

def remove_worker(jobUid:str,workerUid:str):
    global db
    db.collection('jobs').document(jobUid).update({'signedWorkers': cloud.ArrayUnion([workerUid]),'approvedWorkers': cloud.ArrayRemove([f'{workerUid},unseen',f'{workerUid},seen',workerUid])})
if __name__ == "__main__":
    start_server()
    get_reviews_on_user()