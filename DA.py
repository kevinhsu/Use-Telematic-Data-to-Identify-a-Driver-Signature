import numpy as np
from scipy.linalg import eigh
from sklearn import preprocessing

def Discriminant_analysis(X1,X2,gamma=0.01,r=0.1):
    n=X1.shape[0]
    m=X2.shape[0]
    H1=(np.identity(n)-np.ones((n,n))/n)
    H2=(np.identity(m)-np.ones((m,m))/m)    
    X=np.append(X1, X2, axis=0)
    X=preprocessing.scale(X)
    X_norm=np.sum(X*X,axis=1)
    X_norm.shape=(X_norm.shape[0],1)
    G=2.*np.dot(X,X.T)-X_norm-X_norm.T
    K=(np.exp(G*gamma))
    K1=K[:,0:n]
    K2=K[:,n:m+n]
    u1=np.mean(K1,axis=1)
    u1.shape=(u1.shape[0],1)
    u2=np.mean(K2,axis=1)
    u2.shape=(u2.shape[0],1)
    A=np.dot(u1-u2,(u1-u2).T)
    B=np.dot(np.dot(K1,H1),K1.T)+np.dot(np.dot(K2,H2),K2.T)+r*K+0.000001*np.identity(m+n)
    
    _,V=eigh(A,B,eigvals=(n+m-1,n+m-1))    
    Y1=np.dot(K[0:n,:], V)
    Y2=np.dot(K[n:m+n,:], V)
    if np.mean(Y1)<np.mean(Y2):
        Y1=-Y1
        Y2=-Y2
    Y=np.append(Y1,Y2)
    min_max_scaler = preprocessing.MinMaxScaler()
    Y=min_max_scaler.fit_transform(Y) 
    return Y
    