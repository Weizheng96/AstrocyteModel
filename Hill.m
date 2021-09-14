function theta=Hill(C,n,Ka)

theta=(1+(Ka./C).^n).^(-1);

end


% active:
% (1+(0.1/C)^4)^(-1)
% inhibit:
% (1+(C/5)^4)^(-1)
% ip3:
% (1+(K/I)^2)^(-1)

% serca
% (1+(0.5/C))^(-1)

% 