# Linear-sliding-modes
Описание задачи содержится в Оптимальная_стабилизация.docx. Не стал переводить его в LaTeX формат. Помимо самого MATLAB SIMULINK необходимо будет обзавестись библиотеками YALMIP и SeDuMi

# 1.1 Запрос лицензии и установка MATLAB SIMULINK

Для получения лицензионной версии MATLAB SIMULINK необходимо:

1. Подать заявку:
   - **Вариант 1** (для пользователей с доменной почтой университета):  
     [Оформить заявку](https://matlabsupport.ru/)
   - **Вариант 2** (для остальных случаев):  
     [Форма запроса лицензии](https://matlabsupport.bitrix24.site/)

2. Указать контактные данные. На указанную почту придет:
   - Лицензионный ключ
   - Ссылка для скачивания
   - Инструкция по установке

> **Важно!**  
> Устанавливайте программу только в пути, содержащие **латинские символы** (без кириллицы и спецсимволов).

---

# 1.2 Установка YALMIP и SeDuMi

## YALMIP (Yet Another LMI Parser)
Бесплатный инструментарий для MATLAB для решения оптимизационных задач (линейное/квадратичное программирование, задачи с полуопределёнными матрицами).

**Официальный источник**:  
[Инструкция по установке](https://yalmip.github.io/tutorial/installation/)

### Способ установки:
1. Скачайте архив:  
   [GitHub YALMIP](https://github.com/yalmip/yalmip/archive/master.zip)
2. В MATLAB:
   - Откройте вкладку `HOME`
   - Выберите `Set Path`
   - Добавьте пути к распакованным папкам:
     ```
     .../YALMIP-master
     .../YALMIP-master/extras
     .../YALMIP-master/solvers
     .../YALMIP-master/modules
     .../YALMIP-master/modules/parametric
     .../YALMIP-master/modules/moment
     .../YALMIP-master/modules/global
     .../YALMIP-master/modules/sos
     .../YALMIP-master/operators
     ```

## SeDuMi (Self-Dual-Minimization)
Оптимизационный солвер для задач SDP и QP с открытым исходным кодом.

**Установка**:
1. Скачайте решатель:  
   [GitHub SeDuMi](https://github.com/sqlp/sedumi)
2. В MATLAB:
   - Откройте `Set Path`
   - Добавьте путь:  
     `.../sedumi-master`
