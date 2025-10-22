# Berlin Travel Guide
This is a simple travel guide that gives the user a random suggestion of which Berlin attraction to visit first.

## Prerequisites
- Python3
  - flask and flask-cors
  
## Running Locally
Open two Terminals:
1. `cd backend` and `python3 app.py`
2. `cd frontend`and `python3 -m http.server 8000`
Open Tabs in your Browser:
1: `http://localhost:5003/quote` --> You should see a simple quote
2: `http://localhost:8000/index.html`--> You should see a header with a quote from the backend

## Backend
The **Flask** backend maintains a list of popular Berlin attractions, and whenever the API endpoint is called, it returns a random attraction from the list.
- **Flask:** Ligthweight Python framework
- **Flask-CORS**: Enables Cross-Origin Resource Sharing (CORS) for your Flask app

