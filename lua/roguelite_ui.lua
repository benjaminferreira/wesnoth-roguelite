-- roguelite_ui.lua — reusable modal dialog system
local UI = {}

function UI.choose(cfg)
    local title = cfg.title or ""
    local message = cfg.message or ""
    local options = cfg.options or {}
    local selection = 1

    local dialog_wml = {
        definition = "default",
        automatic_placement = false,
        x = "(screen_width / 8)",
        y = "(screen_height / 8)",
        width = "(screen_width * 3 / 4)",
        height = "(screen_height * 3 / 4)",
        wml.tag.linked_group{id="opt_img", fixed_width=true},
        wml.tag.tooltip{id="tooltip"},
        wml.tag.helptip{id="tooltip"},
        wml.tag.grid{
            wml.tag.row{
                wml.tag.column{
                    border="all", border_size=10, horizontal_alignment="center",
                    wml.tag.label{id="dlg_title", definition="title"},
                },
            },
            wml.tag.row{
                wml.tag.column{
                    border="all", border_size=10, horizontal_grow=true,
                    wml.tag.scroll_label{id="dlg_message", definition="default"},
                },
            },
            wml.tag.row{
                grow_factor=1,
                wml.tag.column{
                    horizontal_grow=true, vertical_grow=true, border="all", border_size=5,
                    wml.tag.listbox{
                        id="dlg_options", definition="default",
                        wml.tag.list_definition{
                            wml.tag.row{
                                wml.tag.column{
                                    vertical_grow=true, horizontal_grow=true,
                                    wml.tag.toggle_panel{
                                        definition="default", return_value_id="ok",
                                        wml.tag.grid{
                                            wml.tag.row{
                                                wml.tag.column{
                                                    grow_factor=0, border="all", border_size=5,
                                                    wml.tag.image{id="opt_image", definition="default", linked_group="opt_img"},
                                                },
                                                wml.tag.column{
                                                    grow_factor=1, border="all", border_size=5, horizontal_grow=true,
                                                    wml.tag.label{id="opt_label", definition="default"},
                                                },
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
            wml.tag.row{
                wml.tag.column{
                    horizontal_alignment="right", border="all", border_size=10,
                    wml.tag.button{id="ok", definition="default", label="Select"},
                },
            },
        },
    }

    local function preshow(self)
        self.dlg_title.label = title
        self.dlg_message.label = message
        self.dlg_message.use_markup = true
        local listbox = self.dlg_options
        for _, o in ipairs(options) do
            local item = listbox:add_item()
            if type(o) == "string" then
                item.opt_image.label = ""
                item.opt_label.label = o
            else
                item.opt_image.label = o.image or ""
                local text = o.label or ""
                if o.description then text = text .. "\n<small>" .. o.description .. "</small>" end
                item.opt_label.label = text
                item.opt_label.use_markup = true
            end
        end
        listbox.selected_index = 1
    end

    local function postshow(self)
        selection = self.dlg_options.selected_index
    end

    gui.show_dialog(dialog_wml, preshow, postshow)
    return selection
end

function UI.message(cfg)
    local title = cfg.title or ""
    local message = cfg.message or ""

    local dialog_wml = {
        definition = "default",
        automatic_placement = false,
        x = "(screen_width / 8)",
        y = "(screen_height / 8)",
        width = "(screen_width * 3 / 4)",
        height = "(screen_height * 3 / 4)",
        wml.tag.tooltip{id="tooltip"},
        wml.tag.helptip{id="tooltip"},
        wml.tag.grid{
            wml.tag.row{
                wml.tag.column{
                    border="all", border_size=10, horizontal_alignment="center",
                    wml.tag.label{id="dlg_title", definition="title"},
                },
            },
            wml.tag.row{
                grow_factor=1,
                wml.tag.column{
                    border="all", border_size=20, horizontal_grow=true, vertical_grow=true,
                    wml.tag.scroll_label{id="dlg_message", definition="default"},
                },
            },
            wml.tag.row{
                wml.tag.column{
                    horizontal_alignment="right", border="all", border_size=10,
                    wml.tag.button{id="ok", definition="default", label="Continue"},
                },
            },
        },
    }

    local function preshow(self)
        self.dlg_title.label = title
        self.dlg_message.label = message
        self.dlg_message.use_markup = true
    end

    gui.show_dialog(dialog_wml, preshow)
end

function UI.text_input(cfg)
    local title = cfg.title or ""
    local message = cfg.message or ""
    local default_text = cfg.default_text or ""
    local entered = default_text
    local result = 1

    local dialog_wml = {
        definition = "default",
        automatic_placement = false,
        x = "(screen_width / 6)",
        y = "(screen_height / 4)",
        width = "(screen_width * 2 / 3)",
        height = "(screen_height / 2)",
        wml.tag.tooltip{id="tooltip"},
        wml.tag.helptip{id="tooltip"},
        wml.tag.grid{
            wml.tag.row{
                wml.tag.column{
                    border="all", border_size=10, horizontal_alignment="center",
                    wml.tag.label{id="dlg_title", definition="title"},
                },
            },
            wml.tag.row{
                wml.tag.column{
                    border="all", border_size=10, horizontal_grow=true,
                    wml.tag.label{id="dlg_message", definition="default"},
                },
            },
            wml.tag.row{
                grow_factor=1,
                wml.tag.column{
                    border="all", border_size=10, horizontal_grow=true, vertical_alignment="center",
                    wml.tag.text_box{id="dlg_input", definition="default"},
                },
            },
            wml.tag.row{
                wml.tag.column{
                    horizontal_alignment="right", border="all", border_size=10,
                    wml.tag.grid{
                        wml.tag.row{
                            wml.tag.column{
                                border="all", border_size=5,
                                wml.tag.button{id="back", definition="default", label="← Back", return_value=2},
                            },
                            wml.tag.column{
                                border="all", border_size=5,
                                wml.tag.button{id="ok", definition="default", label="Confirm"},
                            },
                        },
                    },
                },
            },
        },
    }

    local function preshow(self)
        self.dlg_title.label = title
        self.dlg_message.label = message
        self.dlg_input.text = default_text
    end

    local function postshow(self)
        entered = self.dlg_input.text
    end

    result = gui.show_dialog(dialog_wml, preshow, postshow)
    if result == 2 then return nil, 2 end
    return entered, 1
end

-- Multi-select: pick exactly N items from a list.
function UI.multi_choose(cfg)
    local title = cfg.title or ""
    local message = cfg.message or ""
    local options = cfg.options or {}
    local count = cfg.count or 1
    local selected = {}
    local pool = {}
    for i, o in ipairs(options) do
        pool[#pool+1] = {idx=i, opt=o}
    end
    for pick = 1, count do
        if #pool == 0 then break end
        local opts = {}
        for _, p in ipairs(pool) do
            opts[#opts+1] = p.opt
        end
        local prompt = message
        if count > 1 then
            prompt = prompt .. "\n\n<i>Selection " .. pick .. " of " .. count .. "</i>"
        end
        local choice = UI.choose{
            title=title,
            message=prompt,
            options=opts,
        }
        selected[#selected+1] = pool[choice].idx
        table.remove(pool, choice)
    end
    return selected
end

return UI

