<!--
Copyright 2019 Google Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<% BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
   String uploadUrl = blobstoreService.createUploadUrl("/messages"); %>


<!DOCTYPE html>
<html>
  <head>
    <title>User Page</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/user-page.css">
    <script src="/js/navigation-loader.js"></script>
    <script src="/js/user-page-loader.js"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/11.2.0/classic/ckeditor.js"></script>
  </head>
  
  <body onload="addLoginOrLogoutLinkToNavigation();buildUI();">
    <div class="image">
      <img src="webbanner.png" alt="homepage background"
    width="1200" height="400">
    </div>

    <nav>
      <ul id="navigation" class="darkbar">
        <li><a class="barelements" href="/">Home</a></li>
        <li><a class="barelements" href="/aboutus.html">About Our Team</a></li>
        <li><a class="barelements" href="/maps.html">Our Map</a></li>
        <li><a class="barelements" href="/community.html">Community Page</a></li>
      </ul>
    </nav>
     <!-- This allows the user's image and map to be displayed side by side-->
     <div class="wrapper">
      <div>
        <h1 id="page-title">User Page</h1>
        <img src="newUser.jpg" height="350" width="350">
      </div>
      <div>
        <h1>User Map</h1>
        <div id="map"></div>
        <script>
          let map;
          /* Editable marker that displays when a user clicks in the map. */
          let editMarker;
          function createMap(){
            map = new google.maps.Map(document.getElementById('map'), {
              center: {lat: 37.422, lng: -122.084},
              zoom: 16
            });
            // When the user clicks in the map, show a marker with a text box the user can edit.
            map.addListener('click', (event) => {
              createMarkerForEdit(event.latLng.lat(), event.latLng.lng());
            });
            fetchMarkers();
          }
          /** Fetches markers from the backend and adds them to the map. */
          function fetchMarkers(){
            fetch('/markers').then((response) => {
              return response.json();
            }).then((markers) => {
              markers.forEach((marker) => {
               createMarkerForDisplay(marker.lat, marker.lng, marker.content)
              });
            });
          }
          /** Creates a marker that shows a read-only info window when clicked. */
          function createMarkerForDisplay(lat, lng, content){
            const marker = new google.maps.Marker({
              position: {lat: lat, lng: lng},
              map: map
            });
            var infoWindow = new google.maps.InfoWindow({
              content: content
            });
            marker.addListener('click', () => {
              infoWindow.open(map, marker);
            });
          }
          /** Sends a marker to the backend for saving. */
          function postMarker(lat, lng, content){
            const params = new URLSearchParams();
            params.append('lat', lat);
            params.append('lng', lng);
            params.append('content', content);
            fetch('/markers', {
              method: 'POST',
              body: params
            });
          }
          /** Creates a marker that shows a textbox the user can edit. */
          function createMarkerForEdit(lat, lng){
            // If we're already showing an editable marker, then remove it.
            if(editMarker){
             editMarker.setMap(null);
            }
            editMarker = new google.maps.Marker({
              position: {lat: lat, lng: lng},
              map: map
            });
            const infoWindow = new google.maps.InfoWindow({
              content: buildInfoWindowInput(lat, lng)
            });
            // When the user closes the editable info window, remove the marker.
            google.maps.event.addListener(infoWindow, 'closeclick', () => {
              editMarker.setMap(null);
            });
            infoWindow.open(map, editMarker);
          }
          /** Builds and returns HTML elements that show an editable textbox and a submit button. */
          function buildInfoWindowInput(lat, lng){
            const textBox = document.createElement('textarea');
            const button = document.createElement('button');
            button.appendChild(document.createTextNode('Submit'));
            button.onclick = () => {
              postMarker(lat, lng, textBox.value);
              createMarkerForDisplay(lat, lng, textBox.value);
              editMarker.setMap(null);
            };
            const containerDiv = document.createElement('div');
            containerDiv.appendChild(textBox);
            containerDiv.appendChild(document.createElement('br'));
            containerDiv.appendChild(button);
            return containerDiv;
          }
        </script>
        <script async def
          src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBsJSF6Nk4a-dT8609e1u3vl2ImEVJBm3c&callback=createMap">
        </script>
      </div>
    </div>
    <form method="POST" enctype="multipart/form-data" action="<%= uploadUrl %>">
          <p>Enter a new message:</p>
          <textarea name="text" id="message-input"></textarea>
          <br/>
          <p>Upload an image:</p>
          <input type="file" name="image">
          <br/><br/>
          <button>Submit</button>
        </form>
    <hr/>
  <div id="content" style="display: inline-block;">
    <h2>My Posts</h2>
    <div id="message-container">Loading...</div>
  </div>
  </body>
</html>
