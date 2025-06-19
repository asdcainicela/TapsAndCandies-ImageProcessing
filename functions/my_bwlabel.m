function [L, num] = my_bwlabel(BW)
    BW = logical(BW); [rows, cols] = size(BW);
    L = zeros(rows, cols); num = 0;
    directions = [-1, 0; 1, 0; 0, -1; 0, 1]; % 4-conectividad

    for r = 1:rows

        for c = 1:cols

            if BW(r, c) && L(r, c) == 0
                num = num + 1;
                queue = [r, c]; L(r, c) = num;

                while ~isempty(queue)
                    pr = queue(1, 1); pc = queue(1, 2); queue(1, :) = [];

                    for d = 1:size(directions, 1)
                        rr = pr + directions(d, 1); cc = pc + directions(d, 2);

                        if rr >= 1 && rr <= rows && cc >= 1 && cc <= cols

                            if BW(rr, cc) && L(rr, cc) == 0
                                L(rr, cc) = num; queue(end + 1, :) = [rr, cc]; %#ok<AGROW>
                            end

                        end

                    end

                end

            end

        end

    end

end
