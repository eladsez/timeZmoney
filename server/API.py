from flask import Flask, jsonify, request
import firebase_function
app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def handle_request():
    print(request.headers['request'])
    if request.method == 'GET':
        if request.headers['request'] == 'get_user_with_uid':
            user = firebase_function.get_user_by_uid(request.headers['data'])
            return user 
        if request.headers['request'] == 'get_majors':
            majors = firebase_function.get_majors()
            return majors
        if request.headers['request'] == 'get_jobs_of_employer':
            jobs = firebase_function.get_jobs_of_employer(request.headers['data'])
            return jobs
        if request.headers['request'] == 'get_relevant_jobs':
            jobs = firebase_function.get_relevent_jobs()
            return jobs
        if request.headers['request'] == 'get_jobs_of_major':
            jobs = firebase_function.get_jobs_of_major(request.headers['data'])
            return jobs
        if request.headers['request'] == 'get_job_by_uid':
            job = firebase_function.get_job_by_uid(request.headers['data'])
            return job
        if request.headers['request'] == 'get_past_jobs_approved_to':
            jobs = firebase_function.get_past_jobs_approved_to(request.headers['data'])
            return jobs
        if request.headers['request'] == 'get_reviews_on_uid':
            reviews = firebase_function.get_reviews_on_user(request.headers['data'])
            return reviews
    elif request.method == 'POST':
        print(request.form)
        if request.headers['request'] == 'add_worker_to_wait_list':
            firebase_function.add_worker_to_wait_list(request.form['work'],request.form['worker'])
        if request.headers['request'] == 'approve_worker':
            firebase_function.approve_worker(request.form['work'],request.form['worker'])
        if request.headers['request'] == 'remove_worker':
            firebase_function.remove_worker(request.form['work'],request.form['worker'])
        # handle the post request here
        return jsonify(success=True)
    else:
        return jsonify(success=False)

if __name__ == '__main__':
    firebase_function.start_server()
    app.run(port=8000,host='0.0.0.0')
