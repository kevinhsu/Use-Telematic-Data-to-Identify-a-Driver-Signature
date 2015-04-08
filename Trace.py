import os
from math import hypot,acos,pi
import statistics as stat


def smooth(x, y, steps):
    """
    Returns moving average using steps samples to generate the new trace

    Input: x-coordinates and y-coordinates as lists as well as an integer to indicate the size of the window (in steps)
    Output: list for smoothed x-coordinates and y-coordinates
    """
    xnew = []
    ynew = []
    for i in range(steps, len(x)):
        xnew.append(sum(x[i-steps:i]) / float(steps))
        ynew.append(sum(y[i-steps:i]) / float(steps))
    return xnew, ynew


def distance(x0, y0, x1, y1):
    """Computes 2D euclidean distance"""
    return hypot((x1 - x0), (y1 - y0))


def speed_angle_distance(x, y):
    """
    Returns velocities just using difference in distance between coordinates as well as accumulated distances

    Input: x-coordinates and y-coordinates as lists
    Output: list of velocities
    """
    v = []   
    angle = []
    acceleration = []
    deceleration = []
    turning_speed = []
    distancesum = 0.0
    shift = -1
    for i in range(1, len(x)):
        
        dist = distance(x[i-1], y[i-1], x[i], y[i])
        v.append(dist)
        distancesum += dist
        flag = 1
        if i > 1:
            if v[i-1] >= v[i-2]:
                acceleration.append(v[i-1]-v[i-2])
                if flag == 0:
                    shift += 1
                    flag = 1
            else:
                deceleration.append(v[i-2]-v[i-1])
                if flag == 1:
                    shift += 1
                    flag = 0
            dist_2 = distance(x[i-2], y[i-2], x[i], y[i])
            if v[i-1]*v[i-2] != 0.:
                cosin = (v[i-1]**2+v[i-2]**2-dist_2**2)/(2.*v[i-1]*v[i-2])
            else:
                cosin = -1.
            angle.append(pi-acos(max(min(cosin, 1.), -1.)))
            temp = angle[i-2]*(v[i-1]+v[i-2])/2.
            #if temp>0.:
            turning_speed.append(temp)
    # angle=[a for a in angle if a>0.]
    return v, angle,acceleration,deceleration,turning_speed,distancesum,shift


class Trace(object):
    """"
    Trace class reads a trace file and computes features of that trace.
    """

    def __init__(self, filename, filtering=5):
        """Input: path and name of the file of a trace; how many filtering steps should be used for sliding window filtering"""
        self.__id = int(os.path.basename(filename).split(".")[0])
        x = []
        y = []
        with open(filename, "r") as trainfile:
            trainfile.readline()  # skip header
            for line in trainfile:
                items = line.split(",", 2)
                x.append(float(items[0]))
                y.append(float(items[1]))
        self.__xn, self.__yn = smooth(x, y, filtering)
        v, angle, acceleration, deceleration, turning_speed, self.distancecovered, self.shift = speed_angle_distance(self.__xn, self.__yn)

        self.maxspeed = max(v)

        # self.minspeed = min(v)
        self.avespeed = stat.mean(v)
        self.stdspeed = stat.stdev(v)

        self.maxangle = max(angle)
        #self.minangle = min(angle)
        self.aveangle = stat.mean(angle)
        self.stdangle = stat.stdev(angle)

        self.maxacc = max(acceleration)
        #self.minacc = min(acceleration)
        self.stdacc = stat.stdev(acceleration)
        self.numacc = len(acceleration)

        self.maxdec = max(deceleration)
        #self.mindec = min(deceleration)
        self.avedec = stat.mean(deceleration)
        self.stddec = stat.stdev(deceleration)
        self.numdec = len(deceleration)

        self.maxturnv = max(turning_speed)
        #self.minturnv = min(turning_speed)
        self.aveturnv = stat.mean(turning_speed)
        self.stdturnv = stat.stdev(turning_speed)

        self.triplength = distance(x[0], y[0], x[-1], y[-1])
        self.triptime = len(x)

    @property
    def features(self):
        """Returns a list that comprises all computed features of this trace."""
        features = []
        features.append(self.triplength)
        features.append(self.triptime)
        features.append(self.distancecovered)
        features.append(self.shift)
        features.append(self.maxspeed)
        #features.append(self.minspeed)
        features.append(self.avespeed)
        features.append(self.stdspeed)
        features.append(self.maxangle)
        #features.append(self.minangle)
        features.append(self.aveangle)
        features.append(self.stdangle)
        features.append(self.maxacc)
        #features.append(self.minacc)
        features.append(self.aveacc)
        features.append(self.stdacc)
        features.append(self.numacc)
        features.append(self.maxdec)
        #features.append(self.mindec)
        features.append(self.avedec)
        features.append(self.stddec)
        features.append(self.numdec)
        features.append(self.maxturnv)
        #features.append(self.minturnv)
        features.append(self.aveturnv)
        features.append(self.stdturnv)
        return features

    def __str__(self):
        return "Trace {0} has this many positions: \n {1}".format(self.__id, self.triptime)

    @property
    def identifier(self):
        """Driver identifier is its filename"""
        return self.__id
