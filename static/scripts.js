// This is a single JavaScript file housing the functions we need. This will be imported by the HTML.

// this function will make an HTTP request to our app and update the element id=updatetimeresponse with the response
function updateTime() {
  var request = new XMLHttpRequest();
  request.open('GET', '/updatetime', true);
  request.onload = function () {
    var updateTimeResponseTextField = document.getElementById("updatetimeresponse");
    updateTimeResponseTextField.innerHTML = this.response;
  };
  request.send();
}

// this function will make an HTTP request to our app and update the element id=gettimeresponse with the response
function getTime() {
  var request = new XMLHttpRequest();
  request.open('GET', '/gettime', true);
  request.onload = function () {
    var getTimeResponseTextField = document.getElementById("gettimeresponse");
    getTimeResponseTextField.innerHTML = this.response;
  };
  request.send();
}
