function plot_figure(result, range, xlabel_text, method_list, selected_methods)

if nargin ~= 5
  selected_methods = 1 : length(method_list);
end;

figure;
semilogy(range, result(:, selected_methods));
% legend('Dio', 'YIN', 'SWIPE', 'XSX', 'NDF', 'ACDC');
legend(method_list(selected_methods));
grid;
set(gca, 'xlim', [range(1) range(end)]);
xlabel(xlabel_text);
ylabel('RMS error');
