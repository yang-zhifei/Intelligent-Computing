clear all;clc
x=-4:0.02:4;
y=-4:0.02:4;
N=size(x,2);%size(A,1):获取矩阵A的行数 size(A,2):获取矩阵A的列数
for i=1:N
    for j=1:N
        z(j,i)=3*cos(x(i)*y(j))+x(i)+y(j)*y(j);
    end
end
mesh(x,y,z)%mesh()网格曲面图
title('3cos(xy)+x+y^2')
xlabel('x')
ylabel('y')
hold on
N=100;%群体粒子个数
D=2;%粒子维数
T=200;%最大迭代次数
c1=1.5;%学习因子1
c2=1.5;%学习因子2
Wmax=0.8;%惯性权重最大值
Wmin=0.4;%惯性权重最小值
Xmax=4;%位置最大值
Xmin=-4;%位置最小值
Vmax=1;%速度最大值
Vmin=-1;%速度最小值
%%%初始化种群个体（限定位置和速度）%%%
x=rand(N,D)*(Xmax-Xmin)+Xmin;
v=rand(N,D)*(Vmax-Vmin)+Vmin;
%%%初始化个体最有位置和最优值%%%
p=x;%p为个体最优位置pbest为最优值
pbest=ones(N,1);%ones()生成N*1全1数组
for i=1:N
    pbest(i)=func2(x(i,:));
end
%%
figure
a=-4:0.02:4;
b=-4:0.02:4;
n=size(a,2);%size(A,1):获取矩阵A的行数 size(A,2):获取矩阵A的列数
for i=1:n
    for j=1:n
        z(j,i)=3*cos(a(i)*b(j))+a(i)+b(j)*b(j);
    end
end
mesh(a,b,z)%mesh()网格曲面图
title('3cos(xy)+x+y^2')
xlabel('x')
ylabel('y')
x1=x(:,1);
x2=x(:,2);
x3=pbest;
hold on;
scatter3(x(:,1), x(:,2), pbest, 'r*');title('初始状态图');
%%%初始化全局最有位置和最优值%%%
g=ones(1,D);%g为全局最优位置，gbest为全局最优值
gbest=inf;
for i=1:N
    if(pbest(i)<gbest)
        g=p(i,:);
        gbest=pbest(i);
    end
end
gb=ones(1,T);
%%%按照公式一次迭代直到满足精度或者迭代次数%%%
for i=1:T
    for j=1:N
        %%%%更新个体最优位置和最优解%%%
        if(func2(x(j,:))<pbest(j))
            p(j,:)=x(j,:);
            pbest(j)=func2(x(j,:));
        end
        %%%更新全局最优位置和最优解%%%
        if(pbest(j)<gbest)
            g=p(j,:);
            gbest=pbest(j);
        end
        %%%计算动态惯性权重值%%%
        w=Wmax-(Wmax-Wmin)*i/T;%shi提出的线性递减权值策略
        %%%更新位置和速度值%%%
        v(j,:)=w*v(j,:)+c1*rand*(p(j,:)-x(j,:))+c2*rand*(g-x(j,:));
        x(j,:)=x(j,:)+v(j,:);
        %%%便捷条件处理%%%
        for ii=1:D
            if (v(j,ii)>Vmax)||(v(j,ii)<Vmin)
                v(j,ii)=rand*(Xmax-Xmin)+Xmin;
            end
            if(x(j,ii)>Xmax)||(x(j,ii)<Xmin)
                x(j,ii)=rand*(Xmax-Xmin)+Xmin;
            end
        end
    end
    %%%记录历代全局最优解%%%
    gb(i)=gbest;
end
g
%%
figure
a=-4:0.02:4;
b=-4:0.02:4;
n=size(a,2);%size(A,1):获取矩阵A的行数 size(A,2):获取矩阵A的列数
for i=1:n
    for j=1:n
        z(j,i)=3*cos(a(i)*b(j))+a(i)+b(j)*b(j);
    end
end
mesh(a,b,z)%mesh()网格曲面图
title('最终位置图')
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
xlabel('迭代次数');
ylabel('适应度值');
title('适应度进化曲线')
%%
%%适应度函数%%%
function value = func2(x)
value=3*cos(x(1)*x(2))+x(1)+x(2)^2;
end
