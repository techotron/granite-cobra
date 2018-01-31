package granite_cobra.cobraandroid;

import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

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

