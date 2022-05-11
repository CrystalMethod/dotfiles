local status_gps_ok, gps = pcall(require, "nvim-gps")
if not status_gps_ok then
  return
end

gps.setup()
