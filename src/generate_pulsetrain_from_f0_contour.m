function x = generate_pulsetrain_from_f0_contour(f0, fs)

temporal_positions = (0 : length(f0) - 1) / 1000;
signal_time = (0 : 1 / fs : (length(f0) - 1) / 1000);

f0_interpolated = ...
  interp1(temporal_positions, f0, signal_time, 'linear', 'extrap');
total_phase = cumsum(2 * pi * f0_interpolated / fs);
pulse_locations = signal_time(abs(diff(rem(total_phase, 2 * pi))) > pi / 2);
pulse_locations_index = round(pulse_locations * fs) + 1;

x = zeros(length(signal_time), 1);
for i = 1 : length(pulse_locations_index)
  x(pulse_locations_index(i)) = 1;
end;