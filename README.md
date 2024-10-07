# Hydrolyte 💦

Mobile app's source code can be found [here](https://github.com/c25kenneth/Hydrolyte/tree/main/Hydrolyte-Mobile-App/lib).

Server side code can be found [here](https://github.com/c25kenneth/Hydrolyte/tree/main/Hydrolyte-Server).

The code for our machine learning model is [here](https://github.com/c25kenneth/Hydrolyte/tree/main/Hydrolyte-Server/MachineLearning)

## Screenshots

<p align="center">
  <img width="300" alt="Screenshot_1698724058" src="https://github.com/user-attachments/assets/e5da38c8-53a5-4200-a499-6e559370762d">
  <img width="300" alt="Screenshot 2024-08-28 150725" src="https://github.com/user-attachments/assets/b8e5b3bf-be86-4fd6-8c31-d61ff2bca4e3">
  <img width="300" alt="Screenshot 2024-08-28 150903" src="https://github.com/user-attachments/assets/b430fbd7-b866-4e54-a0fd-d4644d2d3ffd">
  <img width="300" alt="Screenshot 2024-08-28 150725" src="https://github.com/user-attachments/assets/b5aeaec9-bdae-43e9-9467-c232f344c7ca">
  <img width="300" alt="Screenshot 2024-08-28 150903" src="https://github.com/user-attachments/assets/9e90fde0-c6ad-45d2-be97-567d71c41da7">
  <img width="300" alt="Screenshot 2024-08-28 150903" src="https://github.com/user-attachments/assets/81194426-4c6e-4850-a0b4-1d9222179b48">
  <img width="300" alt="Screenshot 2024-08-28 150903" src="https://github.com/user-attachments/assets/5143b473-9b2c-4ee7-a279-babd03253053">
</p>


## Inspiration
As an athlete, I’ve seen firsthand how crucial proper hydration is for performance and overall health. Yet, over 75% of people in the United States alone are dehydrated without even realizing it. This gap inspired me to create an app that helps individuals monitor and manage their hydration needs with machine learning.

## What it does
Hydrolyte tracks water intake, provides health insights based on individual factors such as outside temperature/humidity, and offers personalized water-loss predictions to ensure you stay hydrated, healthy, and perform at your best.

## How we built it
We built Hydrolyte using Flutter for a seamless cross-platform experience and integrated Firebase for authentication. For the machine learning side of things, we used scikit-learn and various data analysis libraries to create an ensembled machine learning model (Linear Regression, Bayesian Ridge, and Kernel Ridge). On the backend, we hosted our model with a Flask REST API and connected it to our database, AWS DynamoDB. We incorporated Google Maps, a weather API, and various third-party Dart packages to offer personalized location-based insights.

## Challenges we ran into
It was extremely difficult connecting all the different parts. We built our backend with Python and Flask while our frontend was built with Flutter. Using two different languages and learning how to call all of these APIs while maintaining our app's state was tough, but we got through it. 

## Accomplishments that we're proud of
I'm proud of our machine learning model which predicts total water loss. We achieved mean absolute error of roughly 1.63 which is extremely promising for a regression-based model. It took a lot of time, experimenting with different machine learning algorithms.

## What we learned
We learned the importance of optimizing data handling for real-time predictions, balancing design for both usability and function, and the complexities of hydration science.

## What's next for Hydrolyte
Next, we really want to try exploring the possibilities of our app. For example, we could develop a wearable device that takes in metrics that can be used on our machine learning model to calculate water loss. The device can then connect the app. The possibilities are truly endless with Hydrolyte. 
