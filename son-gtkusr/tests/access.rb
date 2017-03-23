require 'json'
require 'net/http'
require 'jwt'

def parse_json(message)
  # Check JSON message format
  begin
    parsed_message = JSON.parse(message) # parse json message
  rescue JSON::ParserError => e
    # If JSON not valid, return with errors
    return message, e.to_s + "\n"
  end

  return parsed_message, nil
end

# "token_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/token"
def adminbased()
  @@address = 'localhost'
  @port = '8081'
  @uri = 'auth'
  @client_name = 'adapter'
  @client_secret = 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f'
  @access_token = nil

  url = URI('http://' + @@address.to_s + ':' + @port.to_s + '/' + @uri.to_s + '/realms/master/protocol/openid-connect/token')

  res = Net::HTTP.post_form(url, 'client_id' => @client_name, 'client_secret' => @client_secret,
                            'username' => "admin",
                            'password' => "admin",
                            'grant_type' => "password")

  if res.body['access_token']
    parsed_res, code = parse_json(res.body)
    @access_token = parsed_res['access_token']
    puts "ACCESS_TOKEN RECEIVED" , parsed_res['access_token']
    parsed_res['access_token']
  end
end

# "token_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/token"
def userbased
  # curl -d "client_id=admin-cli" -d "username=user1" -d "password=1234" -d "grant_type=password" "http://localhost:8081/auth/realms/SONATA/protocol/openid-connect/token"
  client_id = "adapter"
  username = "tester"
  pwd = "1234"
  grt_type = "password"
  http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/token"
  idp_path = "http://localhost:8081/auth/realms/master/broker/github/login?"
  # puts `curl -X POST --data "client_id=#{client_id}&username=#{usrname}"&password=#{pwd}&grant_type=#{grt_type} #{http_path}`

  uri = URI(http_path)
  # uri = URI(idp_path)
  res = Net::HTTP.post_form(uri, 'client_id' => client_id, 'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
                            'username' => username,
                            'password' => pwd,
                            'grant_type' => grt_type)
  puts "RES.BODY: ", res.body


  if res.body['access_token']
    #if env['HTTP_AUTHORIZATION']
    # puts "env: ", env['HTTP_AUTHORIZATION']
    # access_token = env['HTTP_AUTHORIZATION'].split(' ').last
    # puts "access_token: ", access_token
    # {"access_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyRG1CZm1UaEJEa3NmNElMWVFnVEpSVmNRMDZJWEZYdWNOMzhVWk1rQ0cwIn0.eyJqdGkiOiJjYzY3MmUzYS1mZTVkLTQ4YjItOTQ4My01ZTYxZDNiNGJjMGEiLCJleHAiOjE0NzY0NDQ1OTAsIm5iZiI6MCwiaWF0IjoxNDc2NDQ0MjkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvU09OQVRBIiwiYXVkIjoiYWRtaW4tY2xpIiwic3ViIjoiYjFiY2M4YmQtOTJhMy00N2RkLTliOGUtZDY3NGQ2ZTU0ZjJjIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYWRtaW4tY2xpIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNTkwYzlhNGUtYzljNC00OTU1LTg1NDAtYTViOTM2ODM5NjEzIiwiYWNyIjoiMSIsImNsaWVudF9zZXNzaW9uIjoiYjhkODI4ZjAtNWQ3Yy00NjI4LWEzOTEtNGQwNTY0MDNkNTRjIiwiYWxsb3dlZC1vcmlnaW5zIjpbXSwicmVzb3VyY2VfYWNjZXNzIjp7fSwibmFtZSI6InNvbmF0YSB1c2VyIHNvbmF0YSB1c2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidXNlcjEiLCJnaXZlbl9uYW1lIjoic29uYXRhIHVzZXIiLCJmYW1pbHlfbmFtZSI6InNvbmF0YSB1c2VyIiwiZW1haWwiOiJzb25hdGF1c2VyQHNvbmF0YS5uZXQifQ.T_GB_kBtZk-gmFNJ5rC2sJpNl4V3TUyhixq76hOi5MbgDbo_FfuKRomxviAeQi-RdJPIEffdzrVmaYXZVQHufpaYx9p90GQd3THQWMyZD50zMY40j-XlungaGKjizWNxaywvGXBMvDE_qYp0hr4Uewm4evO_NRRI1bWQLeaeJ3oHr1_p9vFZf5Kh8tZYR-dQSWuESvHhZrJAqHTzXlYYMRBqfjDyAgUhm8QbbtmDtPr0kkkIh1TmXevkZbm91mrS-9jWrS4zGZE5LiT5KdWnMs9P8FBR1p3vywwIu_z-0MF8_DIMJWa7ApZAXjtrszXAYVfCKsaisjjD9HacgpE-4w","expires_in":300,"refresh_expires_in":1800,"refresh_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyRG1CZm1UaEJEa3NmNElMWVFnVEpSVmNRMDZJWEZYdWNOMzhVWk1rQ0cwIn0.eyJqdGkiOiIyOTRmZjc5Yy01ZWIxLTQwNDgtYmM1NS03NjcwOGU1Njg1YzMiLCJleHAiOjE0NzY0NDYwOTAsIm5iZiI6MCwiaWF0IjoxNDc2NDQ0MjkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvU09OQVRBIiwiYXVkIjoiYWRtaW4tY2xpIiwic3ViIjoiYjFiY2M4YmQtOTJhMy00N2RkLTliOGUtZDY3NGQ2ZTU0ZjJjIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImFkbWluLWNsaSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjU5MGM5YTRlLWM5YzQtNDk1NS04NTQwLWE1YjkzNjgzOTYxMyIsImNsaWVudF9zZXNzaW9uIjoiYjhkODI4ZjAtNWQ3Yy00NjI4LWEzOTEtNGQwNTY0MDNkNTRjIiwicmVzb3VyY2VfYWNjZXNzIjp7fX0.WGHvTiVc08xuVCDM5YLlvIzvBgz0aJ3OY3-VGmKSyI-fDLfbp9LSLkPsIqiKO9mDjybSfEkrNmPBd60lWecUC43DacVhVbiLEU9cJdMnjQjrU0P3wg1HFQmcG8exylJMzWoAbJzm893SP-kgKVYCnbQ55Os1-oT1ClHr3Ts6BHVgz5FWrc3dk6DqOrGAxmoJLQUgNJ5jdF-udt-j81OcBTtC3b-RXFXlRu3AyJ0p-UPiu4_HkKBVdg0pmycuN0v0it-TxR_mlM9lhvdVMGXLD9_-PUgklfc6XisdCrGa_b9r06aQCiekXGWptLoFF1Oz__g2_v4Gsrzla5YKBZzGfA","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyRG1CZm1UaEJEa3NmNElMWVFnVEpSVmNRMDZJWEZYdWNOMzhVWk1rQ0cwIn0.eyJqdGkiOiI5NWVmMGY0Yi1lODIyLTQwMTAtYWU1NS05N2YyYTEzZWViMzkiLCJleHAiOjE0NzY0NDQ1OTAsIm5iZiI6MCwiaWF0IjoxNDc2NDQ0MjkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvU09OQVRBIiwiYXVkIjoiYWRtaW4tY2xpIiwic3ViIjoiYjFiY2M4YmQtOTJhMy00N2RkLTliOGUtZDY3NGQ2ZTU0ZjJjIiwidHlwIjoiSUQiLCJhenAiOiJhZG1pbi1jbGkiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI1OTBjOWE0ZS1jOWM0LTQ5NTUtODU0MC1hNWI5MzY4Mzk2MTMiLCJhY3IiOiIxIiwibmFtZSI6InNvbmF0YSB1c2VyIHNvbmF0YSB1c2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidXNlcjEiLCJnaXZlbl9uYW1lIjoic29uYXRhIHVzZXIiLCJmYW1pbHlfbmFtZSI6InNvbmF0YSB1c2VyIiwiZW1haWwiOiJzb25hdGF1c2VyQHNvbmF0YS5uZXQifQ.FrwYdv1S8mqivHjsyA93ycl10z2tisVJraUGcBJzle060nCO69ZEa0fzrMMCbSkjY1JAwjP92d7_ixuWpcUVvQLkesxKOgcBc8LVhClyh3__8p46kIwfrJYMZQt0cJ6f6nASX1yaySE9sDgl3ElkW0vz-i9vhEXkIh6m-EuC7lH0ZIIL-39-occssq7G5hDleDUMThno8sEsl8rgtV-GdAfjKIwi-yOB0X8K1RrfDarccwA3XB0R8nHAbInZGsrF114KsBuaEvWjKki4m86xFkfPPuSlvWaVRtCziiTBqrBZ_Qna6wI9FfAOiTzPXE5AfFtDowih6d-26kT_jd_7GA","not-before-policy":0,"session_state":"590c9a4e-c9c4-4955-8540-a5b936839613"}

    parsed_res, code = parse_json(res.body)
    @access_token = parsed_res['access_token']
    puts "ACCESS_TOKEN RECEIVED", parsed_res['access_token']
    parsed_res['access_token']
  else
    401
  end
end

# "token_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/token"
def clientbased
  # curl -d "client_id=admin-cli" -d "username=user1" -d "password=1234" -d "grant_type=password" "http://localhost:8081/auth/realms/SONATA/protocol/openid-connect/token"
  http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/token"
  # auth = "Basic YWRhcHRlcjpkZjdlODE2ZC0wMzM3LTRmYmUtYTNmNC03YjUyNjNlYWJhOWY=\n"
  # puts `curl -X POST --data "client_id=#{client_id}&username=#{usrname}"&password=#{pwd}&grant_type=#{grt_type} #{http_path}`

  uri = URI(http_path)

  res = Net::HTTP.post_form(uri, 'client_id' => 'adapter',
                            'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
                            'grant_type' => 'client_credentials'
                            )

  puts "RES.HEADER: ", res.header
  puts "RES.BODY: ", res.body


  if res.body['access_token']
    #if env['HTTP_AUTHORIZATION']
    # puts "env: ", env['HTTP_AUTHORIZATION']
    # access_token = env['HTTP_AUTHORIZATION'].split(' ').last
    # puts "access_token: ", access_token
    # {"access_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyRG1CZm1UaEJEa3NmNElMWVFnVEpSVmNRMDZJWEZYdWNOMzhVWk1rQ0cwIn0.eyJqdGkiOiJjYzY3MmUzYS1mZTVkLTQ4YjItOTQ4My01ZTYxZDNiNGJjMGEiLCJleHAiOjE0NzY0NDQ1OTAsIm5iZiI6MCwiaWF0IjoxNDc2NDQ0MjkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvU09OQVRBIiwiYXVkIjoiYWRtaW4tY2xpIiwic3ViIjoiYjFiY2M4YmQtOTJhMy00N2RkLTliOGUtZDY3NGQ2ZTU0ZjJjIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYWRtaW4tY2xpIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNTkwYzlhNGUtYzljNC00OTU1LTg1NDAtYTViOTM2ODM5NjEzIiwiYWNyIjoiMSIsImNsaWVudF9zZXNzaW9uIjoiYjhkODI4ZjAtNWQ3Yy00NjI4LWEzOTEtNGQwNTY0MDNkNTRjIiwiYWxsb3dlZC1vcmlnaW5zIjpbXSwicmVzb3VyY2VfYWNjZXNzIjp7fSwibmFtZSI6InNvbmF0YSB1c2VyIHNvbmF0YSB1c2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidXNlcjEiLCJnaXZlbl9uYW1lIjoic29uYXRhIHVzZXIiLCJmYW1pbHlfbmFtZSI6InNvbmF0YSB1c2VyIiwiZW1haWwiOiJzb25hdGF1c2VyQHNvbmF0YS5uZXQifQ.T_GB_kBtZk-gmFNJ5rC2sJpNl4V3TUyhixq76hOi5MbgDbo_FfuKRomxviAeQi-RdJPIEffdzrVmaYXZVQHufpaYx9p90GQd3THQWMyZD50zMY40j-XlungaGKjizWNxaywvGXBMvDE_qYp0hr4Uewm4evO_NRRI1bWQLeaeJ3oHr1_p9vFZf5Kh8tZYR-dQSWuESvHhZrJAqHTzXlYYMRBqfjDyAgUhm8QbbtmDtPr0kkkIh1TmXevkZbm91mrS-9jWrS4zGZE5LiT5KdWnMs9P8FBR1p3vywwIu_z-0MF8_DIMJWa7ApZAXjtrszXAYVfCKsaisjjD9HacgpE-4w","expires_in":300,"refresh_expires_in":1800,"refresh_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyRG1CZm1UaEJEa3NmNElMWVFnVEpSVmNRMDZJWEZYdWNOMzhVWk1rQ0cwIn0.eyJqdGkiOiIyOTRmZjc5Yy01ZWIxLTQwNDgtYmM1NS03NjcwOGU1Njg1YzMiLCJleHAiOjE0NzY0NDYwOTAsIm5iZiI6MCwiaWF0IjoxNDc2NDQ0MjkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvU09OQVRBIiwiYXVkIjoiYWRtaW4tY2xpIiwic3ViIjoiYjFiY2M4YmQtOTJhMy00N2RkLTliOGUtZDY3NGQ2ZTU0ZjJjIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImFkbWluLWNsaSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjU5MGM5YTRlLWM5YzQtNDk1NS04NTQwLWE1YjkzNjgzOTYxMyIsImNsaWVudF9zZXNzaW9uIjoiYjhkODI4ZjAtNWQ3Yy00NjI4LWEzOTEtNGQwNTY0MDNkNTRjIiwicmVzb3VyY2VfYWNjZXNzIjp7fX0.WGHvTiVc08xuVCDM5YLlvIzvBgz0aJ3OY3-VGmKSyI-fDLfbp9LSLkPsIqiKO9mDjybSfEkrNmPBd60lWecUC43DacVhVbiLEU9cJdMnjQjrU0P3wg1HFQmcG8exylJMzWoAbJzm893SP-kgKVYCnbQ55Os1-oT1ClHr3Ts6BHVgz5FWrc3dk6DqOrGAxmoJLQUgNJ5jdF-udt-j81OcBTtC3b-RXFXlRu3AyJ0p-UPiu4_HkKBVdg0pmycuN0v0it-TxR_mlM9lhvdVMGXLD9_-PUgklfc6XisdCrGa_b9r06aQCiekXGWptLoFF1Oz__g2_v4Gsrzla5YKBZzGfA","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyRG1CZm1UaEJEa3NmNElMWVFnVEpSVmNRMDZJWEZYdWNOMzhVWk1rQ0cwIn0.eyJqdGkiOiI5NWVmMGY0Yi1lODIyLTQwMTAtYWU1NS05N2YyYTEzZWViMzkiLCJleHAiOjE0NzY0NDQ1OTAsIm5iZiI6MCwiaWF0IjoxNDc2NDQ0MjkwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvU09OQVRBIiwiYXVkIjoiYWRtaW4tY2xpIiwic3ViIjoiYjFiY2M4YmQtOTJhMy00N2RkLTliOGUtZDY3NGQ2ZTU0ZjJjIiwidHlwIjoiSUQiLCJhenAiOiJhZG1pbi1jbGkiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI1OTBjOWE0ZS1jOWM0LTQ5NTUtODU0MC1hNWI5MzY4Mzk2MTMiLCJhY3IiOiIxIiwibmFtZSI6InNvbmF0YSB1c2VyIHNvbmF0YSB1c2VyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidXNlcjEiLCJnaXZlbl9uYW1lIjoic29uYXRhIHVzZXIiLCJmYW1pbHlfbmFtZSI6InNvbmF0YSB1c2VyIiwiZW1haWwiOiJzb25hdGF1c2VyQHNvbmF0YS5uZXQifQ.FrwYdv1S8mqivHjsyA93ycl10z2tisVJraUGcBJzle060nCO69ZEa0fzrMMCbSkjY1JAwjP92d7_ixuWpcUVvQLkesxKOgcBc8LVhClyh3__8p46kIwfrJYMZQt0cJ6f6nASX1yaySE9sDgl3ElkW0vz-i9vhEXkIh6m-EuC7lH0ZIIL-39-occssq7G5hDleDUMThno8sEsl8rgtV-GdAfjKIwi-yOB0X8K1RrfDarccwA3XB0R8nHAbInZGsrF114KsBuaEvWjKki4m86xFkfPPuSlvWaVRtCziiTBqrBZ_Qna6wI9FfAOiTzPXE5AfFtDowih6d-26kT_jd_7GA","not-before-policy":0,"session_state":"590c9a4e-c9c4-4955-8540-a5b936839613"}

    parsed_res, code = parse_json(res.body)
    puts "JWT", parsed_res
    @access_token = parsed_res['access_token']
    puts "ACCESS_TOKEN RECEIVED", parsed_res['access_token']
    #parsed_res['access_token']
    parsed_res
  else
    401
  end
end

def get_public_key
  # turn keycloak realm pub key into an actual openssl compat pub key.
  keycloak_config = JSON.parse(File.read('../config/keycloak.json'))
  @s = "-----BEGIN PUBLIC KEY-----\n"
  pub = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0CuLHW/20ixEsPCQkmLduyOuKLapGPO3+PhwYxEusgfxsZFB9ftx3IggKY+xPCfk77tUE0fK5BCqmaYR1DWJ1GYE4SK3Ic/KScCtRHLxcNUT8yzyw7KdaXHCYmLB9UjAZ24Jgx2ILpr6Epa3WV4vH0xTecvLQ4OUsgG0Po2Fa8M670lefP1Wzi8u7qAR5dQpsGL619hc2pB82mTU1ftd1+EfdNvm8O25g/wzeEHZ9AQe+0Lr/JwwsBbKnBbYa3/mMZI8EflZgnIwSOzL6GL3wRhNmNkz2BFcSy9Pd4ZbnSsisiGRkjR7RTtZaUk+s3sq0BVNRHvhw6d8lJUjln6BaQIDAQAB"
  @s += pub.scan(/.{1,64}/).join("\n")
  #@s += keycloak_config['realm-public-key'].scan(/.{1,64}/).join("\n")
  @s += "\n-----END PUBLIC KEY-----\n"
  @key = OpenSSL::PKey::RSA.new @s
  keycloak_pub_key = @key
end

# Token Validation Endpoint
# "token_introspection_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/token/introspect"
def token_validation(token)
  # puts "TEST ACCESS_TOKEN", token
  # decode_token(token, keycloak_pub_key)
  # url = URI("http://localhost:8081/auth/realms/master/clients-registrations/openid-connect/")
  url = URI("http://127.0.0.1:8081/auth/realms/master/protocol/openid-connect/token/introspect")
  # ttp = Net::HTTP.new(url.host, url.port)

  # request = Net::HTTP::Post.new(url.to_s)
  # request = Net::HTTP::Get.new(url.to_s)
  # request["authorization"] = 'bearer ' + token
  # request["content-type"] = 'application/json'
  # body = {"token" => token}

  # request.body = body.to_json

  res = Net::HTTP.post_form(url, 'client_id' => 'adapter',
                            'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
                            'grant_type' => 'client_credentials', 'token' => token)

  puts "RESPONSE_INTROSPECT", res.read_body
  res.read_body
  # RESPONSE_INTROSPECT:
  # {"jti":"bc1200e5-3b6d-43f2-a125-dc4ed45c7ced","exp":1486105972,"nbf":0,"iat":1486051972,"iss":"http://localhost:8081/auth/realms/master","aud":"adapter","sub":"67cdf213-349b-4539-bdb2-43351bf3f56e","typ":"Bearer","azp":"adapter","auth_time":0,"session_state":"608a2a72-198d-440b-986f-ddf37883c802","name":"","preferred_username":"service-account-adapter","email":"service-account-adapter@placeholder.org","acr":"1","client_session":"2c31bbd9-c13d-43f1-bb30-d9bd46e3c0ab","allowed-origins":[],"realm_access":{"roles":["create-realm","admin","uma_authorization"]},"resource_access":{"adapter":{"roles":["uma_protection"]},"master-realm":{"roles":["view-identity-providers","view-realm","manage-identity-providers","impersonation","create-client","manage-users","view-authorization","manage-events","manage-realm","view-events","view-users","view-clients","manage-authorization","manage-clients"]},"account":{"roles":["manage-account","view-profile"]}},"clientHost":"127.0.0.1","clientId":"adapter","clientAddress":"127.0.0.1","client_id":"adapter","username":"service-account-adapter","active":true}
end

# Method that allows end-user authentication through authorized browser
# "authorization_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/auth"
def authorize_browser(token=nil)
  client_id = "adapter"
  @usrname = "user"
  pwd = "1234"
  grt_type = "password"

  query = "response_type=code&scope=openid%20profile&client_id=adapter&redirect_uri=http://127.0.0.1:8081/auth"
  http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/auth" + "?" + query
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  #request["authorization"] = 'bearer ' + token

  response = http.request(request)
  # p "RESPONSE", response.body

  File.open('codeflow.html', 'wb') do |f|
    f.puts response.read_body
  end
end


def authorize(token=nil)
# NOT WORKING
=begin
  http_path = "http://localhost:8081//auth/realms/master/authz/protection/permission"
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  #body = {"ticket" : ${PERMISSION_TICKET}}
  #request.body = body.to_json

  response = http.request(request)
  p "PERM_CODE", response.code
  p "PERM_BODY", response.body
=end


  http_path = "http://localhost:8081/auth/realms/master/authz/authorize"
  # query = "response_type=code&scope=openid%20profile&client_id=adapter&redirect_uri=http://127.0.0.1:8081/auth"
  # http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/auth" + "?" + query
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Post.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  request["content-type"] = 'application/json'
  body = {"ticket" => "None"}
  request.body = body.to_json

  response = http.request(request)
  p "AUTHZ_CODE", response.code
  p "AUTHZ_BODY", response.body
end



# "userinfo_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/userinfo"
def userinfo(token)
  http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/userinfo"
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  # request = Net::HTTP::Post.new(url.to_s)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  #request["content-type"] = 'application/json'
  #body = {}

  #request.body = body.to_json
  response = http.request(request)
  puts "RESPONSE", response.read_body
  response_json = parse_json(response.read_body)[0]
end

# "end_session_endpoint":"http://localhost:8081/auth/realms/master/protocol/openid-connect/logout"
def logout(token, user=nil)
  # user = token['sub']#'971fc827-6401-434e-8ea0-5b0f6d33cb41'
  user = userinfo(token)["sub"]
  p "SUB", user
  # http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/logout"
  http_path ="http://localhost:8081/auth/admin/realms/master/users/#{user}/logout"
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  # request = Net::HTTP::Post.new(url.to_s)
  request = Net::HTTP::Post.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  request["content-type"] = 'application/x-www-form-urlencoded'
  #request["content-type"] = 'application/json'

  #request.set_form_data({'client_id' => 'adapter',
  #                       'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
  #                       'username' => 'user',
  #                       'password' => '1234',
  #                       'grant_type' => 'password'})
  #request.set_form_data('refresh_token' => token)

  #_remove_all_user_sessions_associated_with_the_user

  #request.body = body.to_json

  response = http.request(request)
  puts "RESPONSE CODE", response.code
  # puts "RESPONSE BODY", response.body
  #response_json = parse_json(response.read_body)[0]
end

# Public key used by realm encoded as a JSON Web Key (JWK).
# This key can be used to verify tokens issued by Keycloak without making invocations to the server.
def certificates
  http_path = "http://localhost:8081/auth/realms/master/protocol/openid-connect/certs"
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  # request = Net::HTTP::Post.new(url.to_s)
  request = Net::HTTP::Get.new(url.to_s)
  #request["authorization"] = 'bearer ' + token
  #request["content-type"] = 'application/json'
  #body = {}

  #request.body = body.to_json
  response = http.request(request)
  puts "RESPONSE", response.read_body
  response_json = parse_json(response.read_body)[0]
end

def decode_token(token, keycloak_pub_key)
  @decoded_payload, @decoded_header = JWT.decode token, keycloak_pub_key, true, { :algorithm => 'RS256' }
  # puts "DECODED_TOKEN: ", @decoded_token
  puts "DECODED_HEADER: ", @decoded_header
  puts "DECODED_PAYLOAD: ", @decoded_payload
  return @decoded_header, @decoded_payload
end

# "registration_endpoint":"http://localhost:8081/auth/realms/master/clients-registrations/openid-connect"
def register_client (token, keycloak_pub_key)
  puts "TEST ACCESS_TOKEN", token
  decode_token(token, keycloak_pub_key)
  url = URI("http://localhost:8081/auth/realms/master/clients-registrations/openid-connect/")
  #url = URI("http://127.0.0.1:8081/auth/realms/master/protocol/openid-connect/token/introspect")
  #url = URI("http://127.0.0.1:8081/auth/realms/master/protocol/openid-connect/userinfo")
  http = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Post.new(url.to_s)
  #request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  request["content-type"] = 'application/json'
  body = {#"client_id" => "myclient",
          "client_name" => "myclient",
          "client_secret" => "1234-admin",
          #"directAccessGrantsEnabled" => true,
          #"serviceAccountsEnabled" => true
  }

  request.body = body.to_json

  response = http.request(request)
  puts "RESPONSE", response.read_body
  response_json = parse_json(response.read_body)[0]

  puts "PARSED", response_json

  @reg_uri = response_json['registration_client_uri']
  @reg_token = response_json['registration_access_token']
  @reg_id = response_json['client_id']
  @reg_secret = response_json['client_secret']
  response_json
end

def register_client_bis (token, keycloak_pub_key)
  #puts "TEST ACCESS_TOKEN", token
  #decode_token(token, keycloak_pub_key)
  # url = URI("http://localhost:8081/auth/realms/master/clients-registrations/openid-connect/")
  url = URI("http://localhost:8081/auth/admin/realms/master/clients")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Post.new(url.to_s)
  request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/json'

  body = {
      "clientId": "myclient",
      "surrogateAuthRequired": false,
      "enabled": true,
      "clientAuthenticatorType": "client-secret",
      "secret": "1234",
      "redirectUris": [
          "/auth/myclient"
      ],
      "webOrigins": [],
      "notBefore": 0,
      "bearerOnly": false,
      "consentRequired": false,
      "standardFlowEnabled": true,
      "implicitFlowEnabled": false,
      "directAccessGrantsEnabled": true,
      "serviceAccountsEnabled": true,
      "publicClient": false,
      "frontchannelLogout": false,
      "protocol": "openid-connect",
      "fullScopeAllowed": false
  }


  request.body = body.to_json
  response = http.request(request)
  puts "CODE", response.code
  puts "BODY", response.body
  response_json = parse_json(response.read_body)[0]

  #puts "PARSED", response_json
  response_json
end

def register_user(token) #, username,firstname, lastname, email, credentials)
  body = {"username" => "tester",
          "enabled" => true,
          "totp" => false,
          "emailVerified" => false,
          "firstName" => "User",
          "lastName" => "Sample",
          "email" => "tester.sample@email.com.br",
          "credentials" => [
              {"type" => "password",
               "value" => "1234"}
          ],
          "requiredActions" => [],
          "federatedIdentities" => [],
          "attributes" => {"tester" => ["true"],"admin" => ["false"]},
          "realmRoles" => [],
          "clientRoles" => {},
          "groups" => []}

  url = URI("http://localhost:8081/auth/admin/realms/master/users")
  http = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Post.new(url.to_s)
  request["authorization"] = 'Bearer ' + token

  request["content-type"] = 'application/json'
  request.body = body.to_json

  response = http.request(request)
  puts "REG CODE", response.code
  puts "REG BODY", response.body

  #GET new registered user Id
  url = URI("http://localhost:8081/auth/admin/realms/master/users?username=tester")
  http = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'Bearer ' + token
  request.body = body.to_json

  response = http.request(request)
  puts "ID CODE", response.code
  puts "ID BODY", response.body
  user_id = parse_json(response.body).first[0]["id"]
  puts "USER ID", user_id

  #- Use the endpoint to setup temporary password of user (It will
  #automatically add requiredAction for UPDATE_PASSWORD
  url = URI("http://localhost:8081/auth/admin/realms/master/users/#{user_id}/reset-password")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Put.new(url.to_s)
  request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/json'

  credentials = {"type" => "password",
                  "value" => "1234",
                  "temporary" => "false"}

  request.body = credentials.to_json
  response = http.request(request)
  puts "CRED CODE", response.code
  puts "CRED BODY", response.body

  #- Then use the endpoint for update user and send the empty array of
  #requiredActions in it. This will ensure that UPDATE_PASSWORD required
  #action will be deleted and user won't need to update password again.
  url = URI("http://localhost:8081/auth/admin/realms/master/users/#{user_id}")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Put.new(url.to_s)
  request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/json'

  body = {"requiredActions" => []}

  request.body = body.to_json
  response = http.request(request)
  puts "UPD CODE", response.code
  puts "UPD BODY", response.body
end

def set_user_roles(token)
  #TODO: Implement
end

def login_user_bis (token, username=nil, credentials=nil)
  url = URI("http://localhost:8081/auth/realms/master/protocol/openid-connect/token")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Post.new(url.to_s)
  request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/x-www-form-urlencoded'


  request.set_form_data({'client_id' => 'adapter',
                         'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
                         'username' => 'user',
                         'password' => '1234',
                         'grant_type' => 'password'})

  response = http.request(request)
  # puts "USER ACCESS TOKEN RECEIVED: ", response.read_body
  parsed_res, code = parse_json(response.body)
  puts "USER ACCESS TOKEN RECEIVED: ", parsed_res['access_token']
  parsed_res['access_token']
end

def management(token)
  #pub = get_public_key
  #header, payload = decode_token(token, pub)
  #session = payload['session_state']
  user_id = '971fc827-6401-434e-8ea0-5b0f6d33cb41'
  http_path = "http://localhost:8081/auth/admin/realms/master/users/#{user_id}"
  url = URI(http_path)
  http = Net::HTTP.new(url.host, url.port)
  #request = Net::HTTP::Post.new(url.to_s)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  #request["content-type"] = 'application/x-www-form-urlencoded'
  #request["content-type"] = 'application/json'

  #request.set_form_data({'client_id' => 'adapter',
  #                       'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
  #                       'username' => 'user',
  #                       'password' => '1234',
  #                       'grant_type' => 'password'})
  #request.set_form_data('refresh_token' => token)

  #_remove_all_user_sessions_associated_with_the_user

  #request.body = body.to_json

  response = http.request(request)
  puts "RESPONSE CODE", response.code
  puts "RESPONSE BODY", response.body
end

def set_Keycloak_config()
  #TODO: Implement
  require 'yaml'
=begin
    # Keycloak configuration
    address: localhost
    port: 8081
    uri: auth
    realm: master
    client: adapter
    secret: df7e816d-0337-4fbe-a3f4-7b5263eaba9f
=end
  conf = YAML::load_file('../config/keycloak.yml') #Load
  conf['uri']= 'auth' #Modify
  conf['realm']= 'SONATA' #Modify
  conf['client']= 'adapter' #Modify
  File.open('../config/keycloak.yml', 'w') {|f| f.write conf.to_yaml } #Store
end

def get_client_secret(token, id=nil)
  realm = "master"
  id = "adapter"
  id = "c0253603-dd08-42fb-a48f-c9bedd0c78f3"
  #Get the client secret
  url = URI("http://localhost:8081/auth/admin/realms/#{realm}/clients/#{id}/client-secret")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  #request.basic_auth("admin", "admin")
  request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/json'

  response = http.request(request)
  p "RESPONSE", response
  p "RESPONSE.read_body222", parse_json(response.read_body)[0]
  p "CODE", response.code
end

def get_clients(token, id=nil)
  realm = "master"
  id = "adapter"
  id = "c0253603-dd08-42fb-a48f-c9bedd0c78f3"
  #Get the client secret
  url = URI("http://localhost:8081/auth/admin/realms/#{realm}/clients")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  #request.basic_auth("admin", "admin")
  request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/json'

  response = http.request(request)
  p "RESPONSE", response
  p "RESPONSE.read_body222", parse_json(response.read_body)[0]
  p "CODE", response.code
end

def regenerate_client_secret()
  #Generate a new secret for the client
  #POST /admin/realms/{realm}/clients/{id}/client-secret
end

def full_token(jwt)
  #jwt = {"access_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJqZjQ3WXlHSzQ3VUprLXJ1cUk5RV9IaDhsNS1heHFrMzkxX0NpUUhmTm9nIn0.eyJqdGkiOiJkY2QyODMwMi02Y2VmLTRhYzktYmI0MC1lZjIwODBhMDQ2YjUiLCJleHAiOjE0ODc5MDIyNjAsIm5iZiI6MCwiaWF0IjoxNDg3ODQ4MjYwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvbWFzdGVyIiwiYXVkIjoiYWRhcHRlciIsInN1YiI6ImUyZjdjN2IwLTY4YmEtNDE5NC04N2M5LWU0MmRiYzQyMmZiZCIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFkYXB0ZXIiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0ZmM1ZWUwNS1hNDczLTRjMjQtYWY4ZC1kZTMyMWYxZDA5MTciLCJhY3IiOiIxIiwiY2xpZW50X3Nlc3Npb24iOiI0MDFlMzkzOC00MDE1LTQ4MjgtYjUzMS0zMzM4NmY0MTk4MDMiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiY3JlYXRlLXJlYWxtIiwiYWRtaW4iLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7Im1hc3Rlci1yZWFsbSI6eyJyb2xlcyI6WyJ2aWV3LWlkZW50aXR5LXByb3ZpZGVycyIsInZpZXctcmVhbG0iLCJtYW5hZ2UtaWRlbnRpdHktcHJvdmlkZXJzIiwiaW1wZXJzb25hdGlvbiIsImNyZWF0ZS1jbGllbnQiLCJtYW5hZ2UtdXNlcnMiLCJ2aWV3LWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtZXZlbnRzIiwibWFuYWdlLXJlYWxtIiwidmlldy1ldmVudHMiLCJ2aWV3LXVzZXJzIiwidmlldy1jbGllbnRzIiwibWFuYWdlLWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtY2xpZW50cyJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctcHJvZmlsZSJdfX0sIm5hbWUiOiIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiJ9.I2Thu0T57wdjQxh_nnBSgn-X5t_mlcV0Y4B3R7Vr_BSXjCCWMfyB80KWD5QydYb1TRd-QwqQQRuZBGqeWuwST6oj2YThpAwuZZFvNQgVuK0_4PaXxN1iTPSfKx4p0LrQD2eqZqAnyumEuuM1Vm_xNGIHOhF5rtbpgHiznapq13UdWxGFx1YQd3jwibxSSDdiVEiiHSeSv3Ez8DUgExQuXRW7P7cOVbv4NcB9VWElO_Ut9k9mxJ7VK2oVxz1PnkoB-1wJybiZ-kIB7bCDlkBLyEgOxgW3d5GN4Pbc6l0doaolWkW6XFiFzf7WIz-Mk-sngTdRMFDWVp6GpJvOf0B1Eg","expires_in":54000,"refresh_expires_in":1800,"refresh_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJqZjQ3WXlHSzQ3VUprLXJ1cUk5RV9IaDhsNS1heHFrMzkxX0NpUUhmTm9nIn0.eyJqdGkiOiI2YjM5YTIwZC1lNTU0LTQ1MTUtYWUxNC1hMDExMDdjMjRkZjIiLCJleHAiOjE0ODc4NTAwNjAsIm5iZiI6MCwiaWF0IjoxNDg3ODQ4MjYwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvbWFzdGVyIiwiYXVkIjoiYWRhcHRlciIsInN1YiI6ImUyZjdjN2IwLTY4YmEtNDE5NC04N2M5LWU0MmRiYzQyMmZiZCIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJhZGFwdGVyIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNGZjNWVlMDUtYTQ3My00YzI0LWFmOGQtZGUzMjFmMWQwOTE3IiwiY2xpZW50X3Nlc3Npb24iOiI0MDFlMzkzOC00MDE1LTQ4MjgtYjUzMS0zMzM4NmY0MTk4MDMiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiY3JlYXRlLXJlYWxtIiwiYWRtaW4iLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7Im1hc3Rlci1yZWFsbSI6eyJyb2xlcyI6WyJ2aWV3LWlkZW50aXR5LXByb3ZpZGVycyIsInZpZXctcmVhbG0iLCJtYW5hZ2UtaWRlbnRpdHktcHJvdmlkZXJzIiwiaW1wZXJzb25hdGlvbiIsImNyZWF0ZS1jbGllbnQiLCJtYW5hZ2UtdXNlcnMiLCJ2aWV3LWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtZXZlbnRzIiwibWFuYWdlLXJlYWxtIiwidmlldy1ldmVudHMiLCJ2aWV3LXVzZXJzIiwidmlldy1jbGllbnRzIiwibWFuYWdlLWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtY2xpZW50cyJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctcHJvZmlsZSJdfX19.ZoZFEBlyRMH51qA9S4DCQBtmc8Uq_Q8CGgwxqYK_HBT3TD8peNK4RZynyvSN0iIPlycKFXxJk87-iFc6vD3jNwIjgMSdEcrJEkvKG6y5ZkCTnMZOnSubTdLD2ajbh4N5D06eXEos-ZV_TZbU5x8BDfCLylAUPZtZXQc0cy454JuVcw9Ck49WhjrbFHMZtCBD27tqMW-juHr4-SiiDKcPO7pYBvgWP4BQwlohbZfVIQ-VnS4fEoOXzzrDqf7gFGr0NXox1K-tFh4YJIGujcaqmZfkCDr-UtqWJ3pRS-AmUo-pcLOfrCVk7Tw-SuUuoie6_HUTa41iDqriQZzrTUCVkA","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJqZjQ3WXlHSzQ3VUprLXJ1cUk5RV9IaDhsNS1heHFrMzkxX0NpUUhmTm9nIn0.eyJqdGkiOiI0NTE5OTYwNy0xMzgxLTQ2YjctYjkzNS1lZDQ5MTI2OGVlOWEiLCJleHAiOjE0ODc5MDIyNjAsIm5iZiI6MCwiaWF0IjoxNDg3ODQ4MjYwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvbWFzdGVyIiwiYXVkIjoiYWRhcHRlciIsInN1YiI6ImUyZjdjN2IwLTY4YmEtNDE5NC04N2M5LWU0MmRiYzQyMmZiZCIsInR5cCI6IklEIiwiYXpwIjoiYWRhcHRlciIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjRmYzVlZTA1LWE0NzMtNGMyNC1hZjhkLWRlMzIxZjFkMDkxNyIsImFjciI6IjEiLCJuYW1lIjoiIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4ifQ.TQr3t41wKxmsnCFw2Mf_ZAuKztKbjW042PJoUfRb4xbkuZbtVTF8G69bM9ShefQ93zl8m5uqZRFTsjucuPYgSfpA2XmLQ7T1kw8jbNQOExoJ-S3jrqVBOHeBe999RD5rbxZC4Gjj8rBtlfXsD2u_RG_XhkNyY0njn6D7eeBDTWDKihpi2peRhbT7z5-hIYfjBrSAhdogCLWq2Z-MD4Kh6Vq7TO07F7SWSDDvJn2KoswS02FYXCqTE4GPTTiwNCi_tZcr45hBzTMal7SKlZrzCUZg_X2sKxXY-5RanzNY4KH_fznFCGslmWr6I0g2W0k5-RAZTydyLnyD5bblPiEyHw","not-before-policy":1487259727,"session_state":"4fc5ee05-a473-4c24-af8d-de321f1d0917"}


  keycloak_config = JSON.parse(File.read('../config/keycloak.json'))
  @s = "-----BEGIN PUBLIC KEY-----\n"
  @s += keycloak_config['realm-public-key'].scan(/.{1,64}/).join("\n")
  @s += "\n-----END PUBLIC KEY-----\n"
  key = OpenSSL::PKey::RSA.new @s
  keycloak_pub_key = key

  jwt.each { |k, v|
    puts "k, v", k, v
    unless k == :'expires_in' or k == :'refresh_expires_in' or k == :'token_type' or k == :'not-before-policy' or k == :'session_state'
      # Decodes token;
      begin
        decoded_payload, decoded_header = JWT.decode v, keycloak_pub_key, true, { :algorithm => 'RS256' }
        # puts "DECODED_TOKEN: ", @decoded_token
        puts "DECODED_HEADER: ", decoded_header
        puts "DECODED_PAYLOAD: ", decoded_payload
      rescue JWT::ExpiredSignature => e
        # Handle expired token, e.g. logout user or deny access
        # [403, { 'Content-Type' => 'text/plain' }, ['The token has expired.']]
        p "ERROR:", e
      end

    end
  }
end

def get_role_details(token)
  realm = "master"
  id = "adapter"
  role = "catalogue_guest"
  #url = URI("http://localhost:8081/auth/admin/realms/#{realm}/clients/#{id}/roles/#{role}")
  url = URI("http://localhost:8081/auth/admin/realms/#{realm}/roles/#{role}")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token
  #request["content-type"] = 'application/json'

  response = http.request(request)
  #p "RESPONSE", response
  #p "RESPONSE.read_body", response.read_body
  p "CODE", response.code
  parsed_res, code = parse_json(response.body)
  p "RESPONSE_PARSED", parsed_res["description"].split(",")
end

def get_users(token)
  #url = /admin/realms/{realm}/users
  url = URI("http://localhost:8081/auth/admin/realms/master/users")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token

  response = http.request(request)
  p "CODE", response.code
  p "RESPONSE", response.body

  parsed_res, code = parse_json(response.body)
end

def client_access(token, registration)
  #"client_id"
  #"client_secret"
  uri = registration["registration_client_uri"]
  puts "URI", uri

  url = URI(uri.to_s)
  #url = URI("http://localhost:8081/auth/realms/master/protocol/openid-connect/token")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'Bearer ' + registration["registration_access_token"]
  #request["content-type"] = 'application/x-www-form-urlencoded'

  #request.set_form_data({'client_id' => registration["client_id"],
  #                       'client_secret' => registration["client_secret"],
  #                       #'grant_type' => registration["grant_types"][0]})
  #                       'grant_type' => "client_credentials"})

  response = http.request(request)
  puts "CODE", response.code
  puts "ACCESS TOKEN RECEIVED: ", response.read_body
  parsed_res, code = parse_json(response.body)
end

def service_user(token)
  #GET /admin/realms/{realm}/clients/{id}/service-account-user
  #url = /admin/realms/{realm}/users
  url = URI("http://localhost:8081/auth/admin/realms/master/clients/200f485d-ca5c-4371-8967-603a4ac6ffd0/service-account-user")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Get.new(url.to_s)
  request["authorization"] = 'bearer ' + token

  response = http.request(request)
  p "CODE", response.code
  p "RESPONSE", response.body

  parsed_res, code = parse_json(response.body)
end

def refresh_token(token)
  url = URI("http://localhost:8081/auth/realms/master/protocol/openid-connect/token")
  http = Net::HTTP.new(url.host, url.port)
  request = Net::HTTP::Post.new(url.to_s)
  #request["authorization"] = 'Bearer ' + token
  request["content-type"] = 'application/x-www-form-urlencoded'

  request.set_form_data({'client_id' => 'adapter',
                         'client_secret' => 'df7e816d-0337-4fbe-a3f4-7b5263eaba9f',
                         'grant_type' => 'client_credentials'})

  response = http.request(request)
  puts "REFRESH CODE", response.code
  puts "REFRESH TOKEN BODY", response.body

  unless response.code == '200'
    return response.code.to_i, response.body
  end
  return 200, parse_json(response.body)[0]
end

=begin
"grant_types_supported":["authorization_code","implicit","refresh_token","password","client_credentials"]
"response_types_supported":["code","none","id_token","token","id_token token","code id_token","code token","code id_token token"]
"subject_types_supported":["public"]
"id_token_signing_alg_values_supported":["RS256"]
"userinfo_signing_alg_values_supported":["RS256"]
"request_object_signing_alg_values_supported":["none","RS256"]
"response_modes_supported":["query","fragment","form_post"]
"token_endpoint_auth_methods_supported":["private_key_jwt","client_secret_basic","client_secret_post"]
"token_endpoint_auth_signing_alg_values_supported":["RS256"]
"claims_supported":["sub","iss","auth_time","name","given_name","family_name","preferred_username","email"]
"claim_types_supported":["normal"]
"claims_parameter_supported":false
"scopes_supported":["openid","offline_access"]
"request_parameter_supported":true
"request_uri_parameter_supported":true}
=end

#token = userbased
token = clientbased
#token = adminbased
#pub = get_public_key
#token_validation(token)
# certificates
#authenticate(token)
# userinfo(token)
#token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJ2aGVwSzktY3VfbXVMRS00LUZac0FiMW5oT1o3elU3aXJLbk9jcWoxYzZZIn0.eyJqdGkiOiJhYTQyYTEyMi0xMzA1LTQ1NWEtYjk0My05MWM3NDBmMDBlODkiLCJleHAiOjE0ODgyNzkyNjUsIm5iZiI6MCwiaWF0IjoxNDg4Mjc4OTY1LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvYXV0aC9yZWFsbXMvc29uYXRhIiwiYXVkIjoiYWRhcHRlciIsInN1YiI6ImMzMjBkMGQyLTg4Y2MtNGMxNS1iMGQwLTAyZmY5OGNkNmQ0YSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFkYXB0ZXIiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiJmNjRkNGM2OC0zMjBhLTRkYjMtYmIyOC1jMzgzNWNlODJhZWUiLCJhY3IiOiIxIiwiY2xpZW50X3Nlc3Npb24iOiJlYzQ4MjlkMC0wNjNmLTQwYzEtOTBiMC0wOGE5MTg4ODEwZmUiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDo4MDgxIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFkYXB0ZXIiOnsicm9sZXMiOlsidW1hX3Byb3RlY3Rpb24iXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJ2aWV3LXByb2ZpbGUiXX19LCJjbGllbnRIb3N0IjoiMTcyLjE5LjAuMSIsImNsaWVudElkIjoiYWRhcHRlciIsIm5hbWUiOiIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzZXJ2aWNlLWFjY291bnQtYWRhcHRlciIsImNsaWVudEFkZHJlc3MiOiIxNzIuMTkuMC4xIiwiZW1haWwiOiJzZXJ2aWNlLWFjY291bnQtYWRhcHRlckBwbGFjZWhvbGRlci5vcmcifQ.njVxVlghmVzAoW3nDsA1OnHTb3jBlO5lVjsxu2fjJlT9gM86Z_HjuxnIBZlGwbvl2EXN7SKfma7VptZck2_Z_TiLu4_s79ISdsg_Hx2YymBcSpEjxUiVO8UYa80rDxtPulK5z24MAKodmqbJf1VZWY4Vb7GkFHuPh3EbUQDQNRaXhP7plhfn36xgUTXh-c5oaO4OZvg6VPTKHKAdkEYUacoQP7xc-FxLW8rixT9GUw86dz6BNdww1ezsmBHjyJ0ma4un1COMHDT63k6JAsiVaoWH0rZrT6PzPcX4IldSP7mD9Fq_lY_DE-ATjMx4MDAvApYhWQZPKuHloQ4HkVYo8A"
#decode_token(token, pub)
#registration = register_client(token, pub)
#register_client_bis(token, pub)
#puts "TOKEN", registration["registration_access_token"]
#decode_token(registration["registration_access_token"], pub)
#client_access(token, registration)
#token2 = login_user_bis(token)
#sleep(3)
#logout_user(token,)
#sleep(3)
#token_validation(token)
#management(token)
#logout(token2)
#sleep(2)
#token_validation(token2)
#register_user(token)
#set_Keycloak_config
#get_inst_file
#get_client_secret(token)
get_clients(token['access_token'])
#full_token(token)
# get_role_details(token)
# authorize_browser
#authorize(token)
#get_users(token)
#service_user(token)
#token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJqZjQ3WXlHSzQ3VUprLXJ1cUk5RV9IaDhsNS1heHFrMzkxX0NpUUhmTm9nIn0.eyJqdGkiOiI2YjM5YTIwZC1lNTU0LTQ1MTUtYWUxNC1hMDExMDdjMjRkZjIiLCJleHAiOjE0ODc4NTAwNjAsIm5iZiI6MCwiaWF0IjoxNDg3ODQ4MjYwLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODEvYXV0aC9yZWFsbXMvbWFzdGVyIiwiYXVkIjoiYWRhcHRlciIsInN1YiI6ImUyZjdjN2IwLTY4YmEtNDE5NC04N2M5LWU0MmRiYzQyMmZiZCIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJhZGFwdGVyIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNGZjNWVlMDUtYTQ3My00YzI0LWFmOGQtZGUzMjFmMWQwOTE3IiwiY2xpZW50X3Nlc3Npb24iOiI0MDFlMzkzOC00MDE1LTQ4MjgtYjUzMS0zMzM4NmY0MTk4MDMiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiY3JlYXRlLXJlYWxtIiwiYWRtaW4iLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7Im1hc3Rlci1yZWFsbSI6eyJyb2xlcyI6WyJ2aWV3LWlkZW50aXR5LXByb3ZpZGVycyIsInZpZXctcmVhbG0iLCJtYW5hZ2UtaWRlbnRpdHktcHJvdmlkZXJzIiwiaW1wZXJzb25hdGlvbiIsImNyZWF0ZS1jbGllbnQiLCJtYW5hZ2UtdXNlcnMiLCJ2aWV3LWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtZXZlbnRzIiwibWFuYWdlLXJlYWxtIiwidmlldy1ldmVudHMiLCJ2aWV3LXVzZXJzIiwidmlldy1jbGllbnRzIiwibWFuYWdlLWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtY2xpZW50cyJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctcHJvZmlsZSJdfX19.ZoZFEBlyRMH51qA9S4DCQBtmc8Uq_Q8CGgwxqYK_HBT3TD8peNK4RZynyvSN0iIPlycKFXxJk87-iFc6vD3jNwIjgMSdEcrJEkvKG6y5ZkCTnMZOnSubTdLD2ajbh4N5D06eXEos-ZV_TZbU5x8BDfCLylAUPZtZXQc0cy454JuVcw9Ck49WhjrbFHMZtCBD27tqMW-juHr4-SiiDKcPO7pYBvgWP4BQwlohbZfVIQ-VnS4fEoOXzzrDqf7gFGr0NXox1K-tFh4YJIGujcaqmZfkCDr-UtqWJ3pRS-AmUo-pcLOfrCVk7Tw-SuUuoie6_HUTa41iDqriQZzrTUCVkA"
#code, token_h = refresh_token(token)
#token_validation(token_h["access_token"])



=begin
    "software_version",
    "tos_uri",
    "application_type",
    "redirect_uris",
    "client_id",
    "sector_identifier_uri",
    "request_object_signing_alg",
    "contacts",
    "scope",
    "post_logout_redirect_uris",
    "grant_types",
    "client_id_issued_at",
    "logo_uri",
    "client_secret_expires_at",
    "userinfo_signed_response_alg",
    "policy_uri",
    "id_token_encrypted_response_enc",
    "jwks_uri",
    "id_token_encrypted_response_alg",
    "client_secret",
    "registration_access_token",
    "default_max_age",
    "require_auth_time",
    "subject_type",
    "request_object_encryption_enc",
    "token_endpoint_auth_signing_alg",
    "default_acr_values",
    "request_object_encryption_alg",
    "initiate_login_uri",
    "software_id",
    "token_endpoint_auth_method",
    "jwks",
    "id_token_signed_response_alg",
    "request_uris",
    "client_uri",
    "response_types",
    "userinfo_encrypted_response_enc",
    "registration_client_uri",
    "client_name",
    "userinfo_encrypted_response_alg"
=end