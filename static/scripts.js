function updateTime() {
  var request = new XMLHttpRequest();
  request.open('GET', 'http://localhost:8080/updatetime', true);
  request.onload = function () {
    var updateTimeResponseTextField = document.getElementById("updatetimeresponse");
    updateTimeResponseTextField.innerHTML = this.response;
  };
  request.send();
}

function getTime() {
  var request = new XMLHttpRequest();
  request.open('GET', 'http://localhost:8080/gettime', true);
  request.onload = function () {
    var getTimeResponseTextField = document.getElementById("gettimeresponse");
    getTimeResponseTextField.innerHTML = this.response;
  };
  request.send();
}
