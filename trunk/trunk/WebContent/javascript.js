
function Confirm(what) {
	var Check = confirm(what);
	return Check;
}

function Goto(where) {
	window.location.href = "/WebReports/Controller?action=view&id="+where;
}
