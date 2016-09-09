function f0_contour = generate_f0_contour(basic_f0, vibrato_modulation)
t = (0 : 1200) / 1000;
FL = 25;
% FL = 150;

basic_f0_contour = zeros(1, length(t)) + basic_f0;
delta_f0_contour = FL / 50 * basic_f0 / 100 * (sin(12.7 * 2 * pi * t) + ...
  sin(7.1 * 2 * pi * t) + sin(4.7 * 2 * pi * t));
vibrato_f0_contour = sqrt(vibrato_modulation * basic_f0) * ...
  cos(sqrt(vibrato_modulation * basic_f0) * t);

f0_contour = basic_f0_contour + delta_f0_contour + vibrato_f0_contour;


