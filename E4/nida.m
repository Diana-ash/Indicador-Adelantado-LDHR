function  [n] = nida(z, nvec, s);

% Devuelve los resultados de nid1 en nid.xls

[N m] = size(z);
i = max(round(log(N)),max(nvec)+1);  % Para estudiar el orden utilizamos una aprox, para estimar n*3 (Chui, 1997)
nv = size(nvec,2); 

  %% Estimamos las correlaciones canonicas (valores singulares) entre pasado y futuro:  

[S1] = singval(z, i, 0, s); % 2 = canonica, 1 = no canonica - V.S. No canonicos para el calculo de SVC's 

%Ct = exp(-1.664)*N^(-.89)*i^(1.638);  % nid2
Ct = exp(.33)*N^(-.81424);
Pos = zeros(i,1);
   for k = 1:i
       dn = 2*(k-1)*m;     % A lo Hannan-Deistler 
       Pos(k,1) = S1(k)^2 + dn*Ct;
   end
   
[a1,a2]=min(Pos);n=a2-1;