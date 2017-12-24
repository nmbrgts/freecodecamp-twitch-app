const [localInit, localSave, localDelete, forceSave]
    = (() => {
        const storageLocation =
            "FCC-App-StreamerList"

        const defaultNames = (
            "[ \"OgamingSC2\" " +
            ", \"cretetion\" " +
            ", \"freecodecamp\" " +
            ", \"storbeck\" " +
            ", \"habathcx\" " +
            ", \"RobotCaleb\" " +
            ", \"noobs2ninjas\"]"
        ).toLowerCase()

        const lInit = () => {
            const streamerList: string[] =
                getStreamerList(defaultNames)

            localStorage.removeItem(
                storageLocation,
            )
            localStorage.setItem(
                storageLocation,
                JSON.stringify(streamerList),
            )

            return streamerList
        }

        const lSave = (name: string) => {
            let streamerList: string[] =
                getStreamerList("[]")

            if (!(streamerList as any).includes(name)) {
                streamerList.unshift(name)
            }

            streamerList = streamerList.filter((x) => {
                return typeof (x) === "string"
            })

            localStorage.removeItem(
                storageLocation,
            )
            localStorage.setItem(
                storageLocation,
                JSON.stringify(streamerList),
            )
        }

        const getStreamerList = (dval: string): string[] =>
            JSON.parse(
                localStorage
                    .getItem(storageLocation) || dval,
            )


        const lDelete = (name: string) => {
            let streamerList: string[] =
                getStreamerList("[]")
            if ((streamerList as any).includes(name)) {
                streamerList = streamerList.filter((x) => {
                    return x !== name
                })
            }
            streamerList = streamerList.filter((x) => {
                return typeof (x) === "string"
            })
            localStorage.removeItem(
                storageLocation,
            )
            localStorage.setItem(
                storageLocation,
                JSON.stringify(streamerList),
            )
        }


        const fSave = (streamerList: string[]) => {
            localStorage.removeItem(
                storageLocation,
            )
            localStorage.setItem(
                storageLocation,
                JSON.stringify(streamerList),
            )
        }
        return [lInit, lSave, lDelete, fSave]
    })()
