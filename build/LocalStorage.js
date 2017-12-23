"use strict";
const [localInit, localSave, localDelete] = (() => {
    const storageLocation = "FCC-App-StreamerList";
    const defaultNames = ("[ \"OgamingSC2\" " +
        ", \"cretetion\" " +
        ", \"freecodecamp\" " +
        ", \"storbeck\" " +
        ", \"habathcx\" " +
        ", \"RobotCaleb\" " +
        ", \"noobs2ninjas\"]").toLowerCase();
    const lInit = () => {
        const streamerList = getStreamerList(defaultNames);
        localStorage.removeItem(storageLocation);
        localStorage.setItem(storageLocation, JSON.stringify(streamerList));
        return streamerList;
    };
    const lSave = (name) => {
        let streamerList = getStreamerList("[]");
        if (!streamerList.includes(name)) {
            streamerList.unshift(name);
        }
        streamerList = streamerList.filter((x) => {
            return typeof (x) === "string";
        });
        localStorage.removeItem(storageLocation);
        localStorage.setItem(storageLocation, JSON.stringify(streamerList));
    };
    const getStreamerList = (dval) => JSON.parse(localStorage
        .getItem(storageLocation) || dval);
    const lDelete = (name) => {
        let streamerList = getStreamerList("[]");
        if (streamerList.includes(name)) {
            streamerList = streamerList.filter((x) => {
                return x !== name;
            });
        }
        streamerList = streamerList.filter((x) => {
            return typeof (x) === "string";
        });
        localStorage.removeItem(storageLocation);
        localStorage.setItem(storageLocation, JSON.stringify(streamerList));
    };
    return [lInit, lSave, lDelete];
})();
