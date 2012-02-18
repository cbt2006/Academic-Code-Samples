function showDetails(event) {
	// code for IE
	if(!event) {
		event = window.event;
	}
	var source; // placeholder for clicked cell
	// Firefox/IE
	if(event.target) {
		source = event.target;
	} else if(event.srcElement) {
		source = event.srcElement;
	}
	var desc = source.name + "\n";
	desc += source.getElementsByTagName("span")[0].innerHTML;
	
	alert(desc);
}

function registerEvents() {
	var links = document.getElementsByTagName("a");
	for(var i = 0; i < links.length; i++) {
		var box = links[i];
		if(box.addEventListener) {
			box.addEventListener("click", showDetails, false);
		} else if(box.attachEvent) {
			box.attachEvent("onclick", showDetails);
		} else {
			box.onclick=showDetails;
		}
	}
}

function changeMonth(monthInc) {
	var month = document.getElementById('month');
	var monthVal = eval(month.value);
	monthVal += monthInc;
	month.value = monthVal;
	return true;
}