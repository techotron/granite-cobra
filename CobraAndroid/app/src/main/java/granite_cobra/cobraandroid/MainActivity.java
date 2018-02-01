package granite_cobra.cobraandroid;

import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setCardVisible(false);
    }

    private Card getCard(){
        return new Card();
    }

    public boolean receivedACard;

    public void getACard(View view) {

        Card cardReceived = getCard();

        receivedACard = true;

        ((TextView)findViewById (R.id.quoteTextVew)).setText ('"' + cardReceived.Quote + '"');
        ((TextView)findViewById (R.id.ridiculousnessTextView)).setText (Integer.toString(cardReceived.Ridiculousness));
        ((TextView)findViewById (R.id.offensivenessTextView)).setText (Integer.toString(cardReceived.Offensiveness));
        ((TextView)findViewById (R.id.grammarTextView)).setText (Integer.toString(cardReceived.GrammaticalIncorrectness));
        ((TextView)findViewById (R.id.illegibilityTextView)).setText (Integer.toString(cardReceived.Illegibility));

        setCardVisible(true);
    }

    private void setCardVisible(boolean setToVisible) {
        ConstraintLayout cardContainer = findViewById(R.id.cardContainer);

        if(setToVisible){
            cardContainer.setVisibility(View.VISIBLE);
        }
        else{
            cardContainer.setVisibility(View.INVISIBLE);
        }
    }
}

