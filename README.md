# videoflix_backend



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/videoflix-49808/videoflix_backend.git
git branch -M main
git push -uf origin main
```

Videoflix Backend Server Setup Instructions

1. Install ffmpeg
   sudo apt-get install ffmpeg

2. Install nginx
   sudo apt-get install nginx

3. Configure SSH Key for GitLab Access
   Generate an SSH key to authenticate with GitLab. Replace example@example.com with your email.
   cd /etc/ssh
   ssh-keygen -t rsa -b 4096 -C "example@example.com"  # Press Enter through all prompts
   cat /root/.ssh/id_rsa.pub  # Display the SSH key to add to GitLab

4. Clone the Repository
   In your home directory, clone the repository.
   git clone git@gitlab.com:videoflix-49808/videoflix_backend.git

5. Connect via SFTP with FileZilla
   - Protocol: SFTP
   - Host: 192.168.1.100 (replace with your server's IP)
   - User: root
   - Password: Server password  
   OR configure private key for SSH:
     - Open FileZilla Settings > SFTP and add the private key.

6. Upload .env File
   Copy the .env file from your local videoflix_backend project to the server via SFTP.

7. Update IP in .env File
   Open .env on the server and update the hostname to the server IP.
   nano /home/videoflix_backend/.env  # Replace IP as necessary

8. Install PostgreSQL
   sudo apt install postgresql postgresql-contrib

9. Configure PostgreSQL User
   Login to PostgreSQL and set the password for the postgres user.
   sudo -i -u postgres
   psql
   ALTER USER postgres WITH PASSWORD 'examplepassword';  # Replace with your password
   CREATE DATABASE videoflix;  # Create the Videoflix database
   \q  # Exit PostgreSQL console
   exit  # Exit postgres user

10. Setup Python Virtual Environment
   apt install python3.12-venv
   python3 -m venv /home/videoflix_backend/env  # Create virtual environment in project directory
   source /home/videoflix_backend/env/bin/activate  # Activate virtual environment

11. Install Requirements
   Edit requirements.txt and install dependencies.
   nano requirements.txt  # Remove problematic lines if necessary
   pip install -r requirements.txt

12. Migrate Database
   python3 manage.py makemigrations
   python3 manage.py migrate

13. Update PostgreSQL Configuration for External Access
   Edit PostgreSQL configuration files.
   sudo nano /etc/postgresql/*/main/postgresql.conf  # Uncomment listen_addresses = '*'
   sudo nano /etc/postgresql/16/main/pg_hba.conf  # Add at the end:
   # host    videoflix       postgres        0.0.0.0/0               md5

14. Restart PostgreSQL
   sudo systemctl restart postgresql

15. Install and Configure SSL with Certbot
   sudo systemctl stop nginx
   sudo certbot certonly --standalone -d example-backend.com -d www.example-backend.com
   # Update nginx config with SSL details from Certbot
   sudo systemctl start nginx

16. Install and Configure Supervisor for Background Tasks
   sudo apt update
   sudo apt install supervisor

   Edit configuration for rqworker:
   sudo nano /etc/supervisor/conf.d/rqworker.conf
   # Add:
   # [program:rqworker]
   # command=/home/videoflix_backend/env/bin/python /home/videoflix_backend/manage.py rqworker
   # process_name=%(program_name)s_%(process_num)02d
   # numprocs=3
   # autostart=true
   # autorestart=true
   # stdout_logfile=/var/log/rqworker.log
   # stderr_logfile=/var/log/rqworker_err.log

   Reload and start Supervisor services.
   sudo supervisorctl reread
   sudo supervisorctl update
   sudo supervisorctl start rqworker

17. Configure Gunicorn with Supervisor
   sudo nano /etc/supervisor/conf.d/gunicorn.conf
   # Add:
   # command=/home/videoflix_backend/env/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 videoflix.wsgi:application
   # directory=/home/videoflix_backend
   # user=root
   # autostart=true
   # autorestart=true
   # stdout_logfile=/var/log/gunicorn/gunicorn_stdout.log
   # stderr_logfile=/var/log/gunicorn/gunicorn_stderr.log

   Reload Supervisor and start Gunicorn.
   sudo supervisorctl reread
   sudo supervisorctl update
   sudo supervisorctl start gunicorn

This completes the setup of the Videoflix Backend server.
"""