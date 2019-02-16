app = require '/app'
newroom_view = null
exports.start = ({themes})->
    pi18n = app.getI18n()
    papp = JinrouFront.loadNewRoom()
    Promise.all([pi18n, papp]).then ([i18n, japp])->
        newroom_view = japp.place {
            i18n: i18n
            node: $("#newroom-app").get 0
            themes: themes
            onCreate: (query)->
                new Promise (resolve, reject)->
                    ss.rpc "game.rooms.newRoom", query, (result)->
                        if result?.error?
                            reject result.error
                        else
                            Index.app.showUrl "/room/#{result.id}"
                            resolve()
        }
    form=$("#newroomform")
    # sessionStorageにルーム情報があったらそれを適用する
    if sessionStorage.savedRule
        # まだ消さない（部屋作成後も使用）
        f=form.get 0
        rule=JSON.parse sessionStorage.savedRule
        f.elements["blind"].value=rule.blind
        f.elements["ownerGM"].value= if rule.gm then "yes" else ""
        f.elements["number"].value=rule.maxnumber ? 30

    $("#newroomform").submit (je)->
        je.preventDefault()
        form=je.target
        # 作成
        query=Index.util.formQuery form
        ss.rpc "game.rooms.newRoom", query,(result)->
            if result?.error?
                Index.util.message "エラー",result.error
                return
            Index.app.showUrl "/room/#{result.id}"

    .change (je)->
        ch=je.target
        if ch.name=="usepassword"
            $("#newroomform").get(0).elements["password"].disabled = !ch.checked

    $("#theme").empty()
    select=$("#theme").get 0
    opt=document.createElement "option"
    opt.value = ""
    opt.textContent = "なし"
    select.appendChild opt
    if themes.length == 0
        # if no theme is available,
        # remove the theme selection field.
        $("#theme").closest("p").css "display", "none"
    else
        themes.forEach (doc)->
            opt=document.createElement "option"
            opt.value = doc.value
            opt.textContent = doc.name
            select.appendChild opt

exports.end = ->
    newroom_view?.unmount()
