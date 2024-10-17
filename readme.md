# Enhancing Existing App Functionality and Usability

## Project Overview
This project is focused on improving the **Plant Selector App** originally developed to help users identify suitable plants for dryland ecosystems. The initial version had several issues, including usability problems, unclear navigation, and coding bugs, making it unsuitable for deployment. This enhanced version addresses those problems and adds new features for both customers and administrators.

## Features

### Customer Features
- **Save Filter Results**: Users can save their filtering results for future use.
- **Export to Excel**: Users can export filtered plant results to an Excel file.
- **Enhanced Filtering Interface**: A new progress bar filtering interface designed for mobile usability.
- **Criteria Display**: Filter criteria are displayed alongside results for easy comparison.
- **Percentage Similarity**: Display similarity percentage for each plant based on filtering criteria.
- **Mobile Responsive Design**: Improved design for better usability on smaller screens.
- **Tooltips for Attributes**: Tooltips explain each plant attribute to help users understand the criteria.
- **Profile Customization**: Users can upload personal profile photos.
- **Expand Filter Results**: View the top 20 plants instead of just 10.
- **Navigation Enhancements**: Consistent back button functionality and "Find a Plant" buttons at the top and bottom of the page for easy access.

### Admin Features
- **Add New Plant Criteria**: Admins can add new plant criteria in the management section.
- **Data Synchronization**: Sync data between the app and Excel spreadsheets.
- **Hide Plants**: Admins can hide plants that are under data entry or incomplete.
- **Increased Plant Display**: Manage more plants with a view of 20 plants per page.

## Installation

### Prerequisites
- Python 3.x
- Flask
- MySQL (or any supported database)
- PythonAnywhere for deployment (optional)

### Steps to Install

1. **Clone the Repository**:git clone https://github.com/zhao1411935907/CS_693.git cd CS_693

2. **Install Dependencies**:
pip install -r requirements.txt

3. **Setup the Database**:
- Create a MySQL database.
- Update `config.py` with your database credentials.
- Run the migration to set up tables:
  ```
  python manage.py migrate
  ```

4. **Run the Application**:
python manage.py runserver


5. **Access the App**:
Open `http://localhost:5000` in your browser.

## Usage

### Customer Usage
- **Login/Signup**: Create an account or log in to access the app.
- **Filter Plants**: Use the filtering options to search for plants based on various criteria.
- **Save/Export Results**: Save filtering results or export them to Excel.
- **Profile**: Customize your profile by uploading a photo and viewing your past filter results.

### Admin Usage
- **Manage Plants**: Add, edit, or hide plants in the database.
- **Sync Data**: Update the app data by synchronizing with Excel files.
- **Monitor Plants**: Use the enhanced admin dashboard to view and manage plant data.

## Testing

1. **Unit Tests**:
Run unit tests to verify functionality:
python -m unittest discover tests


2. **Integration Tests**:
Run integration tests to check the interactions between components:
python -m pytest tests/integration


## Deployment
The app is deployed on PythonAnywhere for testing purposes. You can view it live at:
[https://1411935907.pythonanywhere.com](https://1411935907.pythonanywhere.com)

## Project Links
- **GitHub**: [https://github.com/zhao1411935907/CS_693](https://github.com/zhao1411935907/CS_693)
- **Live Demo**: [https://1411935907.pythonanywhere.com](https://1411935907.pythonanywhere.com)

## Future Improvements
- **Integration with External Plant Databases**: Further enhancement to link the app with external sources for more plant data.
- **Advanced Filtering**: Introduce more complex filtering algorithms for better plant selection accuracy.
- **Improved UI/UX**: Additional design improvements to make the user experience even smoother.

## License
This project is licensed under the Lincoln University.


