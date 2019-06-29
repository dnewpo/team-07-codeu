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
    <script src="/js/user-page-loader.js"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/11.2.0/classic/ckeditor.js"></script>
  </head>
  <body onload="buildUI();">
    <nav>
      <ul id="navigation">
        <li><a href="/">Home</a></li>
        <li><a href="/aboutus.html">About Our Team</a></li>
        <li><a href="/maps.html">In The Bay Area?</a></li>
        <li><a href="/community.html">Community Page</a></li>
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
          function createMap(){
            const map = new google.maps.Map(document.getElementById('map'), {
              center: {lat: 37.422, lng: -122.084},
              zoom: 16
            });
          }
        </script>
        <script async def
          src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBsJSF6Nk4a-dT8609e1u3vl2ImEVJBm3c&callback=createMap">
        </script>
      </div>
    </div>

    <form method="POST" enctype="multipart/form-data" action="<%= uploadUrl %>">
          <p>Type some text:</p>
          <textarea name="text" id="message-input"></textarea>
          <br/>
          <p>Upload an image:</p>
          <input type="file" name="image">
          <br/><br/>
          <button>Submit</button>
        </form>
    <hr/>

    <div id="message-container">Loading...</div>

  </body>
</html>
