function x = generate_signal_from_f0_contour(f0_contour, fs, amp, phase)

w0_contour = f0_contour * 2 * pi;

time_axis = (0 : length(w0_contour) - 1) / 1000;
time_axis2 = (0: 1 / fs : time_axis(end));

cumlative_w0_contour = cumsum(w0_contour) / 1000;
cumlative_w0_contour2 = interp1(time_axis, cumlative_w0_contour, time_axis2);

x = zeros(length(cumlative_w0_contour2), 1);

% fft_size = 65536;
% w = (0 : fft_size - 1) * fs / fft_size;
for i = 1 : floor((fs / 2) / max(f0_contour))
%  rand_amp = 10 ^ (rand * amp / 20);
  rand_amp = 10 ^ (rand * amp / 20);
  rand_phase = rand * phase;
  x = x + cos(i * cumlative_w0_contour2' + rand_phase) * rand_amp;
%   plot(w, 20 * log10(abs(fft(x .* blackman(length(x)), fft_size))));
%   grid;
%   pause;
end

x = x ./ sqrt(sum(x .^ 2));
