local Services = {}

Services.Players     = game:GetService("Players")
Services.RunService  = game:GetService("RunService")
Services.HttpService = game:GetService("HttpService")

Services.LocalPlayer = Services.Players.LocalPlayer

return Services
