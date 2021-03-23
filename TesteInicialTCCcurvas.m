 
 clear all
 
 #Variaveis
 
 eo=8.85*(10^-12);
 k=4;
 Vg=4;
 Rep=100;
 passo=0.1;
 Vds=0.1;
 Ids=rand(Rep,2);
 
 #Janela inicial "valores de entrada" (inputdlg para abrir a janela com valores para inserir)
 
 parameters = {'u(cm²*v^-1*s^-1)', 'Z(mm)', 'L(µm)', 'd(nm)', 'Threshold(V)'};
 respjan = inputdlg (parameters, 'Input Parameters');
 
 #conversao de string para numero, com as transformacoes para Metro
 
 u=str2num(respjan{1})*(10^-4);
 Z=str2num(respjan{2})*(10^-3);
 L=str2num(respjan{3})*(10^-6);
 d=str2num(respjan{4})*(10^-9);
 Vth=str2num(respjan{5});
 
 #formula de Ci=(eo*k)/d
 
 Ci=(eo*k)/d;
 
 for Vg=2:11
   for j=1:Rep
     if (Vds<(Vg-Vth))
       Ids(j,1)=(Z/L)*u*Ci*(Vg-Vth-(Vds/2))*Vds;
     elseif (Vds>(Vg-Vth))
       Ids(j,1)=((Z*u*Ci)/(2*L))*((Vg-Vth)^2);
     endif
     Ids(j,2)=Vds;
     Vds=Vds+passo;
     end;
     Vds=0.1;
     if Vg == 2
       x=(Ids(:,2));
       y=(Ids(:,1));
       
     elseif Vg == 4
       x1=(Ids(:,2));
       y1=(Ids(:,1));
       
     elseif Vg == 6
       x2=(Ids(:,2));
       y2=(Ids(:,1));
       
     elseif Vg == 8
       x3=(Ids(:,2));
       y3=(Ids(:,1));
       
     elseif Vg == 10
       x4=(Ids(:,2));
       y4=(Ids(:,1));
       
     endif
     Vg=Vg+1;
   endfor
   
   #Calculo p/ "Output curve" - Regiao linear (Vd<(Vg-Vth)) e Região Saturação (Vd>(Vg-Vth))
   
   #calculo p/ "Transfer curve" - Região Saturação (Vd>(Vg-Vth)) e Regiao linear (Vd<(Vg-Vth))
   Vg=0.1;
   Rep=100;
   for Vds=2:11  
     for j=1:Rep
       if (Vds<(Vg-Vth))
         Idt(j,1)=(Z/L)*u*Ci*(Vg-Vth-(Vds/2))*Vds; 
       elseif (Vds>(Vg-Vth))
         Idt(j,1)=((Z*u*Ci)/(2*L))*((Vg-Vth)^2);
       endif
       Idt(j,2)=Vg;
       Vg=Vg+passo; 
     end
     
     Vg=0.1;
     if Vds==2
       xs=(Idt(:,2));
       ys=(Idt(:,1));
       
     elseif Vds==4
       xs1=(Idt(:,2));
       ys1=(Idt(:,1));
       
     elseif Vds==6
       xs2=(Idt(:,2));
       ys2=(Idt(:,1));
       
     elseif Vds==8
       xs3=(Idt(:,2));
       ys3=(Idt(:,1));
       
     elseif Vds==10
       xs4=(Idt(:,2));
       ys4=(Idt(:,1));
       
     endif
     Vds=Vds+1;
   endfor
   
   # for j=1:Rep
   # if (Vds>(Vg-Vth))
   #Idt(j,1)=(Z/L)*u*Ci*(Vg-Vth-(Vds/2))*Vds;
   #else 
   # Idt(j,1)=Idt(j-1,1);     
   #endif
   
   #Idt(j,2)=Vg;
   #Vg=Vg+passo; 
   
   Resp = questdlg(sprintf(" u = %.4f \n Z = %.3f \n L = %.4f \n d = %.7f \n Vth = %.1f \n ", u,Z,L,d,Vth),'Parameters in meters',"Plot Graphic", "Change Values", "Exit", "Exit");
   
   while (strcmp(Resp, "Exit") != 1)
     
     if (strcmp(Resp, "Plot Graphic") == 1)
       Graph = questdlg("Pick a Graphic", "Question", "Output Curve", "Transfer Curve", "Output Curve");
       
       if (strcmp(Graph, "Output Curve") == 1)
         hold on
         plot(x,y); 
         plot(x1,y1);     
         plot(x2,y2);   
         plot(x3,y3); 
         out=plot(x4,y4);
         title('Output Curve');
         xlabel('Valores variados de Vds(V)');
         ylabel('Valores calculados de Idt(A)');
         legend({'Vds=2','Vds=4','Vds=6','Vds=8','Vds=10'}, "location", "southeast");
         hold off
         waitfor(out);
       else
         hold on
         semilogy(xs,ys); 
         semilogy(xs1,ys1);     
         semilogy(xs2,ys2);   
         semilogy(xs3,ys3); 
         out=semilogy(xs4,ys4);
         title('Transfer Curve');
         xlabel('Valores variados de Vg(V)');
         ylabel('Valores calculados de Idt(A)');
         legend({'Vg=2','Vg=4','Vg=6','Vg=8','Vg=10'}, "location", "southeast");
         hold off
         waitfor(out);
       endif
       
       Resp = questdlg("Valores",'Box Dimensions',"Plot Graphic", "Change Values", "Exit", "Exit");
       endif;
       endwhile;
       
       
       #hold plota todas as curvas no mesmo gráfico
      
      