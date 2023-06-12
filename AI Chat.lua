--[[---------------------------------------------------------
    Name: Chat
    Desc: Allows User to use the Chat command to Chat with AI
-----------------------------------------------------------]]
local function json_encode(obj)
    local function encode_val(val)
        if type(val) == "string" then
            return '"' .. val:gsub('[%c\\"]', {
                ['\n'] = '\\n',
                ['\r'] = '\\r',
                ['\t'] = '\\t',
                ['"'] = '\\"',
                ['\\'] = '\\\\',
            }) .. '"'
        elseif type(val) == "number" or type(val) == "boolean" then
            return tostring(val)
        elseif type(val) == "table" then
            local parts = {}
            for k, v in pairs(val) do
                table.insert(parts, json_encode(k) .. ":" .. encode_val(v))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        else
            return "null"
        end
    end
    return encode_val(obj)
end
--method: 'POST',headers: {'Content-Type': 'application/json',},body: JSON.stringify(data),
--conversationId = result.jailbreakConversationId;conversationData.value = {jailbreakConversationId: result.jailbreakConversationId,parentMessageId: result.messageId,
--{"message":"text","stream":flase,"clientOptions":{"clientToUse":"bing"},"shouldGenerateTitle":true,"jailbreakConversationId":true,"toneStyle":"creative"}
local function Chat( player, command, arguments )
    if ( !player:IsAdmin() ) then return end

    local text = arguments[1];
    --fetch请求到http://127.0.0.1:7896/conversation,等待获取结果result后输出,
     local result = http.Fetch("http://127.0.0.1:7896/conversation", {
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
        },
        body = json_encode({
            message = text,
            stream = false,
            clientOptions = {
                clientToUse = "bing",
            },
            shouldGenerateTitle = true,
            jailbreakConversationId = true,
            toneStyle = "creative",
        })
        });
    print(result);
end

concommand.Add( "chat", Chat, nil, "", { FCVAR_DONTRECORD } )