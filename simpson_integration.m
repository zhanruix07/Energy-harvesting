function I = simpson_integration(y, h)
    n = length(y);
    if mod(n, 2) == 0
        % 如果数据点是偶数，使用辛普森1/3规则处理除最后一个点外的所有点，对最后一个点使用梯形规则
        I = (h/3) * (y(1) + 4*sum(y(2:2:end-2)) + 2*sum(y(3:2:end-3)) + y(end-1)) ...
            + h * (y(end-1) + y(end)) / 2;
    else
        % 如果数据点是奇数，可以直接使用辛普森1/3规则
        I = (h/3) * (y(1) + 4*sum(y(2:2:end)) + 2*sum(y(3:2:end-2)) + y(end));
    end
end
