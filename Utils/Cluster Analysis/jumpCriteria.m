function [bestClust,J] = jumpCriteria(X,nD,K,type)

nIt = 20;
p = size(X,2);
d = zeros(numel(K),nIt);
Y = nD./2;% number of effective dimensions/2

switch type
    case 'Kmeans'
        n = 1;
        for k=K
            for it = 1:nIt
                [U, Z] = kmeans(X, k, 'emptyaction', 'singleton');
                % calculate distortion
                b = zeros(k,1);
                for i=1:k
                    S = eye(p);%S = cov(X(U==i,:)); for GMM
                    a = bsxfun(@minus, X(U==i,:), Z(i,:));
                    b(i) = sum(diag(a*inv(S)*a'))/sum(U==i);
                end
                % average distortion
                d(n,it) = mean(b/p);
            end
            n = n+1;
        end
    case 'GMM'
        disp('GMM not yet supported')
end

J = mean(d(1:end,:).^(-Y)-[zeros(1,nIt); d(1:end-1,:).^(-Y)],2);
[~,bestClust] = max(J);
bestClust = K(bestClust);

% figure;subplot(2,1,1); plot(K, mean(d,2), 'Linewidth',2); title('Distortion');
% subplot(2,1,2); plot(K, J, 'Linewidth',2); title('Jump Result');


end