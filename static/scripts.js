function updateTime() {
  var request = new XMLHttpRequest();
  request.open('GET', 'http://localhost/updatetime', true);
  request.onload = function () {
    var updateTimeResponseTextField = document.getElementById("updatetimeresponse");
    updateTimeResponseTextField.innerHTML = this.response;
  };
  request.send();
}

function getTime() {
  var request = new XMLHttpRequest();
  request.open('GET', 'http://localhost/gettime', true);
  request.onload = function () {
    var getTimeResponseTextField = document.getElementById("gettimeresponse");
    getTimeResponseTextField.innerHTML = this.response;
  };
  request.send();
}
