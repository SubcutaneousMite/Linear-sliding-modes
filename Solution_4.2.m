% Определение матриц A, B, Q и R
A = [0 1 0; -4.2 -1.5 4.2; 0.77 0 0.77];
B = [0; -7.4; 0];

q = 3; % Простейший случай, где Q = q*I
Q = q*eye(size(A,1));
R = 1;

% Создание переменных X, Y и гамма
X = sdpvar(3, 3, 'symmetric');
Y = sdpvar(3, 1);
gamma = sdpvar(1);

% Задание начального состояния
x0 = [0.5; 0; 0];

% Определение линейного матричного неравенства (LMIs) и ограничений
LMIs = [A*X + X*A' + B*Y' + Y*B' <= 0;
[gamma, x0'; x0, X] >= 0];

% Минимизация гаммы под ограничениями
optimize(LMIs, gamma);

% Получение значений матриц X и Y
X_val = value(X);
Y_val = value(Y);

% Вычисление матрицы K
if isequal(rank(X_val), size(X_val, 1))
K = Y_val' * inv(X_val)';
else
disp('Матрица X вырождена, невозможно построить график');
return;
end

% Время симуляции
t = linspace(0, 5, 1000);

% Решение уравнения состояния
A_closed = A + B * K;
[~, x] = ode45(@(t, x) A_closed * x, t, x0);

% Построение графика
figure;
plot(t, x(:, 1), t, x(:, 2), t, x(:, 3));
xlabel('Время, сек');
ylabel('Значения состояний');
legend('x_1', 'x_2', 'x_3');
grid on;

% Расширение графика по оси Oy
cur_lim = ylim();
new_lim = cur_lim * 10;
ylim(new_lim);

% Вычисление управления
u = zeros(size(t)); % инициализация вектора управления
for i = 1:length(t)
u(i) = K * x(i, :)'; % умножение i-той строки вектора x на матрицу K
end

% Добавление управления на график
figure;
plot(t, u);
xlabel('Время, сек');
ylabel('Управление');
grid on;

% Вывод значений вектора состояния x и управления u
fprintf('Время \t x1 \t x2 \t x3 \t u\n');
for i = 1:length(t)
fprintf('%.2f \t %.4f \t %.4f \t %.4f \t %.4f\n', t(i), x(i, 1), x(i, 2), x(i, 3), u(i));
end

Оптимальная стабилизация линейной системы импульсным управлением
function main
% Объявление глобальных переменных
global U_saved T_saved;
U_saved = []; % Сохранение значений управления
T_saved = []; % Сохранение временных точек управления

% Определение параметров системы
A = [0 1; -1 0];
B = [0; 1];
Phi = [1 0; 0 1];

% Начальное приближение для матрицы K
K0 = zeros(1, 2); % 1x2 матрица

% Функция стоимости, основанная на уравнении Риккати
objectiveFunction = @(K) ...
norm(-K*A - A'*K' + (K*B*Phi + Phi*B)*(B'*Phi*B)^(-1)*(B'*Phi' + (A'*K')*B') - Phi, 'fro');

% Опции для оптимизатора
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter', 'MaxFunctionEvaluations', 10000);

% Поиск оптимального K
[K_opt, fval, exitflag, output] = fmincon(objectiveFunction, K0, [], [], [], [], [], [], [], options);

% Вывод результатов оптимизации
disp('Оптимизированная матрица K:');
disp(K_opt);
disp('Значение функции стоимости:');
disp(fval);

% Параметры замкнутой системы с оптимизированным K
A_cl = A - B * K_opt;

% Собственные значения замкнутой системы для проверки устойчивости
eigenvalues = eig(A_cl);
disp('Собственные значения замкнутой системы:');
disp(eigenvalues);

% Начальные условия для симуляции
x0 = [0.3; -0.5];

% Временной диапазон и шаг
tspan = [0 100];
h = 0.05; % Шаг интеграции

% Введение параметров для начального импульса
impulseDuration = 0.3; % продолжительность начального импульса
delta = 120; % коэффициент уменьшения начального импульса

% Запуск интеграции с помощью метода Рунге-Кутты 4-го порядка
[t, x] = ode4(@(t, x) dynamics(t, x, A_cl, B, K_opt, impulseDuration, delta), tspan, x0, h);

% Визуализация результатов симуляции состояний
figure;
plot(t, x);
xlim([0, 5]); % Ограничиваем ось времени для увеличения детализации начала
xlabel('Время, сек');
ylabel('Значение состояний');
title('График временного поведения вектора состояния x(t)');
legend('x1', 'x2');

figure;
plot(T_saved, U_saved, 'LineWidth', 2);
xlim([0, 5]); % То же самое для графика управления
xlabel('Время, сек');
ylabel('Управление, u(t)');
title('График изменения управления');
grid on;

% Функция динамики системы с управлением
function dx = dynamics(t, x, A_cl, B, K_opt, impulseDuration, delta)
% Управление с измененным импульсом в начальный момент
if t < impulseDuration
u = -delta * K_opt * x; % Уменьшенный начальный импульс
else
u = -K_opt * x; % Обычное управление
end
% Сохранение значения управления
U_saved = [U_saved, u];
T_saved = [T_saved, t];
dx = A_cl * x + B * u;
end

% Метод Рунге-Кутты 4-го порядка для решения ОДУ
function [t, y] = ode4(dydt, tspan, y0, h)
t = tspan(1):h:tspan(2);
y = zeros(numel(y0), numel(t));
y(:,1) = y0;

for i = 1:numel(t)-1
k1 = dydt(t(i), y(:,i));
k2 = dydt(t(i) + 0.5*h, y(:,i) + 0.5*h*k1);
k3 = dydt(t(i) + 0.5*h, y(:,i) + 0.5*h*k2);
k4 = dydt(t(i) + h, y(:,i) + h*k3);
y(:,i+1) = y(:,i) + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end
end
end