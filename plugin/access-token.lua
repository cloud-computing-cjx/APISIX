local core = require("apisix.core")
local pairs       = pairs
local type        = type
local ngx         = ngx


local schema = {
    type = "object",
    properties = {
        app_key = {
            type = "string"
        },
        access_token = {
            type = "string"
        },
    },
    -- required = {"app_key", "access_token"},
}

local plugin_name = "access-token"

local _M = {
    version = 0.1,
    priority = 25000,
    name = plugin_name,
    schema = schema,
}


function _M.check_schema(conf)
    local ok, err = core.schema.check(schema, conf)
    if not ok then
        return false, err
    end

    return true
end


local function fetch_access_token(ctx)
    local app_key = core.request.header(ctx, "app_key")
    local access_token = core.request.header(ctx, "access_token")

    message = app_key .. "cjx"

    local md5 = require 'md5'
    local md5_as_hex   = md5.sumhexa(message)
    core.log.warn("app_key: ", app_key)
    core.log.warn("access_token: ", access_token)
    core.log.warn("md5_as_hex: ", md5_as_hex)

    if access_token == md5_as_hex then
        return false
    end
    return true
end


function _M.access(conf, ctx)
    local err = fetch_access_token(ctx)
    if err then
        return 200, {message = "access_token Invalid, authentication failed"}
    end
end


return _M
