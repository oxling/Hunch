# Hunch API Demo
This app requests restaurants that it thinks I'll like (based on my twitter handle).

## General Overview
The app downloads a list of recommendations in the area shown on the map. It then requests additional details for these results, filling in the latitude and longitude. Each ``HunchResult`` object is then added to the map as an annotation.

You can request new results by moving the map and hitting "search."

Tapping on the callout in a map annotation brings you to a detail screen, which shows an image of the recommendation.

## To-Do
Future changes:
1. Add error handling (network conditions, malformed requests, etc.)
2. Allow the user to specify their own username
3. Add more information to the detailed screen 
