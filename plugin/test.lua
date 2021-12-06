
app_key = "123456"
message = app_key .. "cjx"

local md5 = require 'md5'

local md5_as_data  = md5.sum(message)       -- returns raw bytes
local md5_as_hex   = md5.sumhexa(message)   -- returns a hex string
local md5_as_hex2  = md5.tohex(md5_as_data) -- returns the same string as md5_as_hex

print(md5_as_data)
print(md5_as_hex)
print(md5_as_hex2)

if "6f3365418a91c38f73e171148898b625" == md5_as_hex then
    print(true)
end