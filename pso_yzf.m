clear all;clc
x=-4:0.02:4;
y=-4:0.02:4;
N=size(x,2);%size(A,1):��ȡ����A������ size(A,2):��ȡ����A������
for i=1:N
    for j=1:N
        z(j,i)=3*cos(x(i)*y(j))+x(i)+y(j)*y(j);
    end
end
mesh(x,y,z)%mesh()��������ͼ
title('3cos(xy)+x+y^2')
xlabel('x')
ylabel('y')
hold on
N=100;%Ⱥ�����Ӹ���
D=2;%����ά��
T=200;%����������
c1=1.5;%ѧϰ����1
c2=1.5;%ѧϰ����2
Wmax=0.8;%����Ȩ�����ֵ
Wmin=0.4;%����Ȩ����Сֵ
Xmax=4;%λ�����ֵ
Xmin=-4;%λ����Сֵ
Vmax=1;%�ٶ����ֵ
Vmin=-1;%�ٶ���Сֵ
%%%��ʼ����Ⱥ���壨�޶�λ�ú��ٶȣ�%%%
x=rand(N,D)*(Xmax-Xmin)+Xmin;
v=rand(N,D)*(Vmax-Vmin)+Vmin;
%%%��ʼ����������λ�ú�����ֵ%%%
p=x;%pΪ��������λ��pbestΪ����ֵ
pbest=ones(N,1);%ones()����N*1ȫ1����
for i=1:N
    pbest(i)=func2(x(i,:));
end
%%
figure
a=-4:0.02:4;
b=-4:0.02:4;
n=size(a,2);%size(A,1):��ȡ����A������ size(A,2):��ȡ����A������
for i=1:n
    for j=1:n
        z(j,i)=3*cos(a(i)*b(j))+a(i)+b(j)*b(j);
    end
end
mesh(a,b,z)%mesh()��������ͼ
title('3cos(xy)+x+y^2')
xlabel('x')
ylabel('y')
x1=x(:,1);
x2=x(:,2);
x3=pbest;
hold on;
scatter3(x(:,1), x(:,2), pbest, 'r*');title('��ʼ״̬ͼ');
%%%��ʼ��ȫ������λ�ú�����ֵ%%%
g=ones(1,D);%gΪȫ������λ�ã�gbestΪȫ������ֵ
gbest=inf;
for i=1:N
    if(pbest(i)<gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
gb=ones(1,T);
%%%���չ�ʽһ�ε���ֱ�����㾫�Ȼ��ߵ�������%%%
for i=1:T
    for j=1:N
        %%%%���¸�������λ�ú����Ž�%%%
        if(func2(x(j,:))<pbest(j))
            p(j,:)=x(j,:);
            pbest(j)=func2(x(j,:));
        end
        %%%����ȫ������λ�ú����Ž�%%%
        if(pbest(j)<gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        %%%���㶯̬����Ȩ��ֵ%%%
        w=Wmax-(Wmax-Wmin)*i/T;%shi��������Եݼ�Ȩֵ����
        %%%����λ�ú��ٶ�ֵ%%%
        v(j,:)=w*v(j,:)+c1*rand*(p(j,:)-x(j,:))+c2*rand*(g-x(j,:));
        x(j,:)=x(j,:)+v(j,:);
        %%%�����������%%%
        for ii=1:D
            if (v(j,ii)>Vmax)||(v(j,ii)<Vmin)
                v(j,ii)=rand*(Xmax-Xmin)+Xmin;
            end
            if(x(j,ii)>Xmax)||(x(j,ii)<Xmin)
                x(j,ii)=rand*(Xmax-Xmin)+Xmin;
            end
        end
    end
    %%%��¼����ȫ�����Ž�%%%
    gb(i)=gbest;
end
g
%%
figure
a=-4:0.02:4;
b=-4:0.02:4;
n=size(a,2);%size(A,1):��ȡ����A������ size(A,2):��ȡ����A������
for i=1:n
    for j=1:n
        z(j,i)=3*cos(a(i)*b(j))+a(i)+b(j)*b(j);
    end
end
mesh(a,b,z)%mesh()��������ͼ
title('����λ��ͼ')
xlabel('x')
ylabel('y')
hold on
zlim=get(gca,'Zlim');
for k = zlim(1):0.5:zlim(2)
    plot3(g(1),g(2),k,'r.')
    hold on 
end
%%
gb(end)
figure
plot(gb)
xlabel('��������');
ylabel('��Ӧ��ֵ');
title('��Ӧ�Ƚ�������')
%%
%%��Ӧ�Ⱥ���%%%
function value = func2(x)
value=3*cos(x(1)*x(2))+x(1)+x(2)^2;
end
