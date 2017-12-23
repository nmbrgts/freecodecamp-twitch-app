var _a = (function () {
    var storageLocation = "FCC-App-StreamerList";
    var defaultNames = ("[ \"OgamingSC2\" " +
        ", \"cretetion\" " +
        ", \"freecodecamp\" " +
        ", \"storbeck\" " +
        ", \"habathcx\" " +
        ", \"RobotCaleb\" " +
        ", \"noobs2ninjas\"]").toLowerCase();
    var lInit = function () {
        var streamerList = getStreamerList(defaultNames);
        localStorage.removeItem(storageLocation);
        localStorage.setItem(storageLocation, JSON.stringify(streamerList));
        return streamerList;
    };
    var lSave = function (name) {
        var streamerList = getStreamerList("[]");
        if (!streamerList.includes(name)) {
            streamerList.unshift(name);
        }
        streamerList = streamerList.filter(function (x) {
            return typeof (x) === "string";
        });
        localStorage.removeItem(storageLocation);
        localStorage.setItem(storageLocation, JSON.stringify(streamerList));
    };
    var getStreamerList = function (dval) {
        return JSON.parse(localStorage
            .getItem(storageLocation) || dval);
    };
    var lDelete = function (name) {
        var streamerList = getStreamerList("[]");
        if (streamerList.includes(name)) {
            streamerList = streamerList.filter(function (x) {
                return x !== name;
            });
        }
        streamerList = streamerList.filter(function (x) {
            return typeof (x) === "string";
        });
        localStorage.removeItem(storageLocation);
        localStorage.setItem(storageLocation, JSON.stringify(streamerList));
    };
    return [lInit, lSave, lDelete];
})(), localInit = _a[0], localSave = _a[1], localDelete = _a[2];
