--------------------------------------------------------------------------------
--- This script is mainly designed to be used to help you understand HOW to 
--- send your data to the Metrics platform logit.io
--- logit.io is a paid service, I am not affiliated with them in any way.
-------------------------------------- Gimpeh


--------------------------------------------------------------------------------
--- This is the stuff you need to set.

--your remote write URL goes here
local remote_write_URL = "urlnonsense, ending in /write"

-- this is for the CSV format, you can change this to whatever you want
-- accepts arbitrary number of fields, but the fields must be in the correct order
-- they also correllate to postData below. column_pos 1 is GOOG in this instance. 4.56 is bid. etc.
-- the metrics each contain all the labels. The labels each contain the same data for the given metric.
-- So ask is 1 value (an actual number 1.23).. and has the market and ticker labels contained within it. (both equaling 1.23)
-- extentensive info on this can be found here: https://docs.victoriametrics.com/single-server-victoriametrics/#how-to-import-csv-data

local default_format = {
  { column_pos = 1, type = "label", context = "ticker" },
  { column_pos = 2, type = "metric", context = "ask" },
  { column_pos = 3, type = "metric", context = "bid" },
  { column_pos = 4, type = "label", context = "market" }
}
--GOOG is at column_pos 1, 1.23 is at column_pos 2, 4.56 is at column_pos 3, NYSE is at column_pos 4... these are the above label and metrics values.
-- Example data payload correllating with above.
local postData = "GOOG,1.23,4.56,NYSE"

--below is the script. Change it around, rip it apart, run it as is.. whatever you want. The values above are the data.
------------------------------------------------------------------

local component = require("component")
local internet = require("internet")

-- Function to parse the URL and extract components
local function parse_url(remote_write_URL)
  -- Find the username:password and the rest of the URL
  local userinfo, rest = remote_write_URL:match("https://(.-)@(.*)")
  
  -- Separate the username and password from the userinfo
  local metricsUsername, metricsPassword = userinfo:match("(.-):(.*)")
  
  -- Remove '/write' from the URL and replace it with '/import/csv?format='
  local modified_rest = rest:gsub("/write", "/import/csv?format=")
  
  -- Return the parts we need
  return metricsUsername, metricsPassword, modified_rest
end

-- Function to build the CSV format string from a user-defined table
local function build_csv_format(format_table)
  local format_string = ""
  for _, field in ipairs(format_table) do
    format_string = format_string .. field.column_pos .. ":" .. field.type .. ":" .. field.context .. ","
  end
  -- Remove the trailing comma
  return format_string:sub(1, -2)
end

-- Parse the URL to extract credentials and the base URL
local metricsUsername, metricsPassword, rest_of_url = parse_url(remote_write_URL)

-- Base64-encode the username:password using component.data.encode64()
local auth_string = metricsUsername .. ":" .. metricsPassword
local encodedAuth = "Basic " .. component.data.encode64(auth_string)

-- Build the CSV format string from the default table
local csv_format = build_csv_format(default_format)

-- Headers (matching the working version)
local headers = {
  ["Authorization"] = encodedAuth,
  ["Content-Type"] = "application/x-www-form-urlencoded",
  ["User-Agent"] = "curl/8.7.1",
  ["Host"] = rest_of_url:match("([^/]+)"),  -- Extract the host from the rest of the URL
  ["Accept"] = "*/*",
  ["Content-Length"] = tostring(#postData)
}

-- Final URL with the dynamically built CSV format string
local final_url = "https://" .. rest_of_url .. csv_format

-- Perform the request using the modified URL and postData
local request = internet.request(final_url, postData, headers)

print("completed data upload")
