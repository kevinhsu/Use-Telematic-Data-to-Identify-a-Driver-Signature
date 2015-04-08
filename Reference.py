import os
from Trace import Trace
from random import sample

class Reference(object):
    """"
    Reference class assigns traces in sub-directories to the driver in a given foldername.
    """

    def __init__(self, foldername):
        """
        Reference Driver with a foldername.
        """
        self._id = int(os.path.basename(foldername))
        self._traces = []
        file_num = len(os.listdir(foldername))
        files = ['%d.csv' % (i) for i in range(1, file_num+1)]
        filename = files[sample(range(1, file_num+1), 1)[0] - 1]
        self._traces.append(Trace(os.path.join(foldername, filename)))

    def __str__(self):
        return "Driver {0} has {1} traces".format(self._id, len(self._traces))

    @property
    def identifier(self):
        """Returns driver identifier determined by its folder name."""
        return self._id

    @property
    def traces(self):
        """Returns all traces of a driver."""
        return self._traces

    @property
    def trace(self, index):
        """Returns trace specified by the index. (Note that in this competition each driver has 200 traces.)"""
        return self._traces[index]

    @property
    def num_features(self):
        """Returns the number of features based on trace 0."""
        return len(self._traces[0].features)

    @property
    def generate_data_model(self):
        """Returns a list of all features for all traces."""
        listoffeatures = []
        for i in range(len(self._traces)):
            listoffeatures.append(self._traces[i].features)
        return listoffeatures
