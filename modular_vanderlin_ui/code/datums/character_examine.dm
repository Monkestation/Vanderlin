/// Осмотр персонажа из лобби (по мотивам ExaminePanel из Twilight-Axis).
/// Берёт данные из листа персонажа, поэтому всегда показывает ТЕКУЩИЙ черновик.
/datum/character_examine
    var/datum/sheet
    var/list/links = list()

/datum/character_examine/New(datum/sheet_datum)
    . = ..()
    sheet = sheet_datum

/datum/character_examine/Destroy()
    sheet = null
    return ..()

/datum/character_examine/ui_state(mob/user)
    return GLOB.always_state

/datum/character_examine/ui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "CharacterExamine")
        ui.open()

/datum/character_examine/ui_static_data(mob/user)
    var/list/data = list()
    if(!sheet)
        return data
    var/list/sheet_data = sheet.ui_data(user)
    if(!islist(sheet_data))
        return data
    for(var/key in sheet_data)
        data[key] = sheet_data[key]
    links = list()
    for(var/link_key in list("ooc_extra_link", "headshot_link", "nudeshot_link"))
        var/value = sheet_data[link_key]
        if(istext(value))
            links[link_key] = value
    return data

/datum/character_examine/ui_data(mob/user)
    return list()

/datum/character_examine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
    . = ..()
    if(.)
        return
    switch(action)
        if("open_link")
            var/which = params["which"]
            var/url = links[which]
            if(!istext(url) || !length(url))
                return TRUE
            if(!findtext(url, "http://", 1, 8) && !findtext(url, "https://", 1, 9))
                return TRUE
            usr << link(url)
            return TRUE
        if("refresh")
            update_static_data(usr)
            return TRUE