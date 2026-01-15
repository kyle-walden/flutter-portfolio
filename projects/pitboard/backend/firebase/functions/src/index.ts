// stubbed: TS for function exports and route registration (thin bootstrap)
import * as functions from 'firebase-functions';
import { SessionAggregator } from './services/sessionAggregator';

// Initialize services
const sessionAggregator = new SessionAggregator();

// HTTP function to aggregate session data
export const aggregateSessions = functions.https.onRequest(async (req, res) => {
  try {
    const sessions = req.body.sessions;
    if (!Array.isArray(sessions)) {
      res.status(400).send('Invalid sessions data');
      return;
    }

    const aggregatedData = sessionAggregator.aggregateSessions(sessions);
    res.status(200).json(aggregatedData);
  } catch (error) {
    console.error('Error aggregating sessions:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Additional function exports can be added here