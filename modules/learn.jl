module Learn

using ScikitLearn

export kmeans, logistic, sgd

function kmeans(X,y)
    @sk_import cluster: KMeans
    model = KMeans(n_clusters=10, random_state=0)
    fit!(model, X, y)
    accuracy = sum(predict(model, X) .== y) / length(y)
    println("accuracy:\t$(Int(floor(10000*accuracy))/100)%")
    model,accuracy
end

function logistic(X,y)
    @sk_import linear_model: LogisticRegression
    model = LogisticRegression(fit_intercept=true)
    fit!(model, X, y)
    accuracy = sum(predict(model, X) .== y) / length(y)
    println("accuracy:\t$(Int(floor(10000*accuracy))/100)%")
    model,accuracy
end

function sgd(X,y;loss="hinge")
    @sk_import linear_model: SGDClassifier
    model = SGDClassifier(loss=loss, penalty="l2", shuffle=true, max_iter=1000, tol=1e-3)
    fit!(model, X, y)
    accuracy = sum(predict(model, X) .== y) / length(y)
    println("accuracy:\t$(Int(floor(10000*accuracy))/100)%")
    model,accuracy
end

end
