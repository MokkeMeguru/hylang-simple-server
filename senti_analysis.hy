;; require 'pip install twython'
(import [nltk.sentiment.vader [SentimentIntensityAnalyzer]]
        nltk)

;; (.download nltk "vader_lexicon")
(setv vader-analyzer (SentimentIntensityAnalyzer))

(defn get-senti [text]
  (.polarity_scores vader_analyzer text))
