function cent = freq2cent(freq)
cent = 1200 * log2((freq + 0.00000001) / (440 * 2^((3/12) - 1))) + 4800;
% ’†‰›ƒn‰¹(C4)‚ğ4800‚Æ‚·‚éD
% ‚Â‚Ü‚èC0‚ª0 Hz‚É‚È‚éD