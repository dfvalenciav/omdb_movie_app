# **OMDb Movie App**

A Flutter application to search for movies and view detailed information using the OMDb API. The app features a clean architecture, responsive UI, and comprehensive error handling.

---

## **Features**

- **Search Movies**: Search for movies by name and view a list of results.
- **Movie Details**: View detailed information such as the plot, director, actors, runtime, and genre.
- **Responsive Design**: Optimized for various screen sizes.
- **Error Handling**: Displays appropriate messages for API errors or no network connection.

---

## **Project Setup in Android Studio**

Follow these steps to set up and run the OMDb Movie App in Android Studio.

### **Prerequisites**

1. **Install Flutter**: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).
2. **Install Android Studio**: [Android Studio Installation Guide](https://developer.android.com/studio).
3. **Set up Flutter Plugin in Android Studio**:
    - Open Android Studio.
    - Go to **Settings > Plugins**.
    - Search for `Flutter` and install it (the Dart plugin will be installed automatically).

---

## **Clone the Repository**

Clone this repository to your local machine:

    git clone <repository-url>
    cd omdb_movie_app


## **Running the App**

### **Steps in Android Studio**

1. **Open the Project**:
   - Open Android Studio.
   - Click **Open** and navigate to the `omdb_movie_app` folder.

2. **Install Dependencies**:
   - Open the terminal in Android Studio.
   - Run the following command to install all dependencies:
     ```bash
     flutter pub get
     ```

3. **Connect a Device**:
   - Connect an Android device to your computer via USB, or start an Android emulator.

4. **Run the App**:
   - In Android Studio, click the green **Run** button or use:
     ```bash
     flutter run
     ```

---

## **Testing the App**

The app includes unit tests for API integration, repositories, and Bloc state management.

### **Run Tests**

Run all tests in the terminal:

flutter test

## **Generate Test Coverage Report (Optional)**

To generate a test coverage report:

    flutter test --coverage
    genhtml coverage/lcov.info -o coverage/html

## **App Architecture**

This app is built using **Clean Architecture**, with three main layers:

### **Presentation Layer**
- Handles the UI and user interaction.
- Uses the **Bloc** pattern for state management.

### **Domain Layer**
- Contains core business logic, such as use cases and entities.
- **Example use cases**:
    - **SearchMovies**: Fetches a list of movies based on a query.
    - **GetMovieDetails**: Fetches detailed information about a movie.

### **Data Layer**
- Handles data fetching from the OMDb API using the `http` package.
- Converts API responses into domain entities using models.

---

## **API Integration**

The app integrates with the **OMDb API** for fetching movie data:

- **Search Movies**:
  https://www.omdbapi.com/?apikey=<your_api_key>&s=<query>


- **Get Movie Details**:
  https://www.omdbapi.com/?apikey=<your_api_key>&i=<movie_id>

### **Setting Up Your API Key**

1. Open `lib/data/datasources/movie_remote_data_source.dart`.
2. Replace `<your_api_key>` with your OMDb API key:
 
 final String apiKey = "your_api_key";

## **Folder Structure**

The project is organized as follows:

lib/ ├── core/ │ ├── error/ │ │ ├── exceptions.dart │ │ └── failures.dart │ └── usecases/ │ └── usecase.dart ├── data/ │ ├── datasources/ │ │ └── movie_remote_data_source.dart │ ├── models/ │ │ ├── movie_model.dart │ │ └── movie_details_model.dart │ └── repositories/ │ └── movie_repository_impl.dart ├── domain/ │ ├── entities/ │ │ ├── movie.dart │ │ └── movie_details.dart │ ├── repositories/ │ │ └── movie_repository.dart │ └── usecases/ │ ├── search_movies.dart │ └── get_movie_details.dart ├── presentation/ │ ├── bloc/ │ │ ├── movie_bloc.dart │ │ ├── movie_event.dart │ │ └── movie_state.dart │ └── pages/ │ ├── search_page.dart │ └── details_page.dart └── main.dart

## **Contributing**

1. **Fork the repository**.
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature
## **Commit Your Changes**

1. **Commit your changes**:
   ```bash
   git commit -m "Add your feature"
   
## **Push to Your Branch**

Push your committed changes to your branch:

    git push origin feature/your-feature

## **License**

## FINAL RESULT 

# Hardcoded sign in
![Screenshot 2025-02-02 at 11 54 26 AM](https://github.com/user-attachments/assets/036d489f-0705-4a49-a4cf-b611248cdba5)

# Search and favorites
![Screenshot 2025-02-02 at 11 55 30 AM](https://github.com/user-attachments/assets/330a4883-e84e-4c05-87bf-811db04a415b)
![Screenshot 2025-02-02 at 11 55 46 AM](https://github.com/user-attachments/assets/69f7c9a3-2f00-4b47-b5c8-652c62553cbd)
![Screenshot 2025-02-02 at 11 56 13 AM](https://github.com/user-attachments/assets/03899972-ee78-4c7d-9435-8c706f75dad1)

# Database
Due to the nature of the project and kind of data needed to be stored. I choose a sqlite local database, with this solution the data can be save and retrieve faster and consistency

# Total amount of hours spent : 4 h




    This project is licensed under the MIT License.
